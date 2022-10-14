defmodule BitpandaApi.Api.Public.Assets do
  @moduledoc """
  Get assets API requests
  """

  import Brex.Result.Base
  import Brex.Result.Helpers
  import Brex.Result.Mappers

  alias BitpandaApi.Asset
  alias BitpandaApi.Api.Error
  alias HTTPoison
  alias Poison

  @default_page_params "?page=0&page_size=500"

  @doc """
  Collect all assets on Bitpanda by asset class
  """
  @spec get_by_class(Asset.class()) :: {:ok, [Asset.t()]} | {:error, Error.t()}
  def get_by_class(class) do
    fetch_assets([], class, @default_page_params)
  end

  @doc """
  Collect all assets on Bitpanda by asset class; raising an exception on error
  """
  @spec get_by_class!(Asset.class()) :: [Asset.t()]
  def get_by_class!(class) do
    class
    |> get_by_class()
    |> extract!()
  end

  @spec fetch_assets([Asset.t()], Asset.class(), String.t() | nil) ::
          {:ok, [Asset.t()]} | {:error, Error.t()}
  defp fetch_assets(assets, _, nil), do: ok(assets)

  defp fetch_assets(assets, class, next) do
    next
    |> url(class)
    |> HTTPoison.get()
    |> bind(&process_response(&1, class))
    |> bind(fn {new_assets, next_req} ->
      assets
      |> Enum.concat(new_assets)
      |> fetch_assets(class, next_req)
    end)
  end

  @spec process_response(
          HTTPoison.Response.t(),
          Asset.class()
        ) ::
          {:ok, {[Asset.t()], String.t() | nil}} | {:error, Error.t()}
  defp process_response(response, class) do
    response
    |> Map.get(:body)
    |> Poison.decode(%{keys: :atoms})
    |> map_error(&Error.parse_error(inspect(&1)))
    |> bind(&json_to_assets(&1, class))
  end

  @spec json_to_assets(%{data: [map()], links: map()}, Asset.class()) ::
          {:ok, {[Asset.t()], String.t() | nil}} | {:error, Error.t()}
  defp json_to_assets(%{data: data, links: links}, class) do
    data
    |> map_while_success(&asset_data_to_asset(&1, class))
    |> fmap(&{&1, Map.get(links, :next)})
  end

  @spec asset_data_to_asset(
          %{attributes: %{symbol: String.t(), name: String.t()}, id: String.t()},
          Asset.class()
        ) :: {:ok, Asset.t()} | {:error, Error.t()}
  defp asset_data_to_asset(%{attributes: %{symbol: symbol, name: name}, id: id}, class),
    do:
      ok(%{
        id: id,
        name: name,
        symbol: symbol,
        type: class
      })

  defp asset_data_to_asset(_, _),
    do: error(Error.parse_error("missing attribute in asset data"))

  @spec api_class(Asset.class()) :: String.t()
  defp api_class(:commodity), do: "etc"
  defp api_class(:cryptocurrency), do: "cryptocoin"
  defp api_class(:etf), do: "etf"
  defp api_class(:metal), do: "metal"
  defp api_class(:stock), do: "stock"

  @spec url(String.t(), Asset.class()) :: String.t()
  defp url(next_req_params, class),
    do: "https://api.bitpanda.com/v3/assets#{next_req_params}&type[]=#{api_class(class)}"
end
