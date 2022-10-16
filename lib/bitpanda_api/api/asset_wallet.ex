defmodule BitpandaApi.Api.AssetWallet do
  @moduledoc """
  API request to collect user's asset wallets
  """

  import Brex.Result.Base
  import Brex.Result.Helpers
  import Brex.Result.Mappers

  alias BitpandaApi.Api.Error
  alias BitpandaApi.Entity.Asset
  alias BitpandaApi.Entity.AssetWallet
  alias BitpandaApi.Utils
  alias Decimal

  @type wallet_data :: %{
          id: String.t(),
          type: String.t(),
          attributes: %{
            cryptocoin_id: String.t(),
            cryptocoin_symbol: String.t(),
            balance: String.t(),
            is_default: boolean(),
            name: String.t(),
            deleted: boolean()
          }
        }

  @doc """
  Get user's asset wallets
  """
  @spec get(String.t()) :: {:ok, [AssetWallet.t()]} | {:error, Error.t()}
  def get(apikey) do
    "#{BitpandaApi.user_api_url()}/asset-wallets"
    |> HTTPoison.get([{"X-API-KEY", apikey}])
    |> map_error(&Error.http_error(&1))
    |> bind(&parse_response(Map.get(&1, :body), Map.get(&1, :status_code)))
  end

  @doc """
  Get user's asset wallets; raise exception on error
  """
  @spec get!(String.t()) :: [AssetWallet.t()]
  def get!(apikey) do
    apikey
    |> get()
    |> extract!()
  end

  @spec parse_response(String.t(), integer()) :: {:ok, [AssetWallet.t()]} | {:error, Error.t()}
  defp parse_response(body, 200) do
    body
    |> Poison.decode(%{keys: :atoms})
    |> map_error(&Error.parse_error(inspect(&1)))
    |> bind(&json_to_wallets(&1))
  end

  defp parse_response(_, 401), do: error(Error.unauthorized())
  defp parse_response(_, _), do: error(Error.server_error())

  @spec json_to_wallets(%{data: %{attributes: map()}}) ::
          {:ok, [AssetWallet.t()]} | {:error, Error.t()}
  defp json_to_wallets(%{data: %{attributes: attributes}}) do
    [:cryptocoin, :commodity, :index, :security]
    |> Enum.map(&{&1, Map.get(attributes, &1)})
    |> Enum.filter(fn {_, obj} -> is_map(obj) end)
    |> reduce_while_success([], fn {category, entry}, acc ->
      entry
      |> parse_wallet_category(category)
      |> fmap(&Enum.concat(acc, [&1]))
    end)
  end

  @spec parse_wallet_category(map(), atom()) :: {:ok, [AssetWallet.t()]} | {:error, Error.t()}
  defp parse_wallet_category(wallets, :cryptocoin),
    do: parse_wallet_collection(wallets, :cryptocurrency)

  defp parse_wallet_category(%{index: wallets}, :index),
    do: parse_wallet_collection(wallets, :cryptocurrency)

  defp parse_wallet_category(%{metal: wallets}, :commodity),
    do: parse_wallet_collection(wallets, :metal)

  defp parse_wallet_category(securities, :security) do
    [:etf, :stock, :etc]
    |> Enum.map(&{&1, Map.get(securities, &1)})
    |> Enum.filter(fn {_, obj} -> is_map(obj) end)
    |> reduce_while_success([], fn {class, entry}, acc ->
      entry
      |> parse_wallet_collection(class)
      |> fmap(&Enum.concat(acc, [&1]))
    end)
  end

  @spec parse_wallet_collection(%{attributes: %{wallets: [wallet_data()]}}, Asset.class()) ::
          {:ok, [AssetWallet.t()]} | {:error, Error.t()}
  defp parse_wallet_collection(%{attributes: %{wallets: wallets}}, class),
    do: map_while_success(wallets, &data_to_wallet(&1, class))

  @spec data_to_wallet(wallet_data(), Asset.class()) ::
          {:ok, AssetWallet.t()} | {:error, Error.t()}
  defp data_to_wallet(
         %{
           type: "wallet",
           id: id,
           attributes: %{
             cryptocoin_id: asset_id,
             cryptocoin_symbol: symbol,
             balance: balance,
             is_default: is_default,
             name: name,
             deleted: deleted
           }
         },
         class
       ) do
    ok(%AssetWallet{
      asset_id: asset_id,
      asset_symbol: symbol,
      balance: Utils.decimal!(balance),
      class: class,
      deleted: deleted,
      id: id,
      is_default: is_default,
      name: name
    })
  catch
    error ->
      error(Error.parse_error(inspect(error)))
  end

  defp data_to_wallet(data, _),
    do: error(Error.parse_error("bad wallet attributes: #{inspect(data)}"))
end
