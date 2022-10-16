defmodule BitpandaApi.Api.CryptoWallet do
  @moduledoc """
  API request to collect user's crypto wallets
  """

  import Brex.Result.Base
  import Brex.Result.Helpers
  import Brex.Result.Mappers

  alias BitpandaApi.Api.Error
  alias BitpandaApi.Entity.CryptoWallet
  alias BitpandaApi.Utils
  alias Decimal

  @doc """
  Get user's crypto wallets
  """
  @spec get(String.t()) :: {:ok, [CryptoWallet.t()]} | {:error, Error.t()}
  def get(apikey) do
    "#{BitpandaApi.user_api_url()}/wallets"
    |> HTTPoison.get([{"X-API-KEY", apikey}])
    |> map_error(&Error.http_error(&1))
    |> bind(&parse_response(Map.get(&1, :body), Map.get(&1, :status_code)))
  end

  @doc """
  Get user's crypto wallets; raise exception on error
  """
  @spec get!(String.t()) :: [CryptoWallet.t()]
  def get!(apikey) do
    apikey
    |> get()
    |> extract!()
  end

  @spec parse_response(String.t(), integer()) :: {:ok, [CryptoWallet.t()]} | {:error, Error.t()}
  defp parse_response(body, 200) do
    body
    |> Poison.decode(%{keys: :atoms})
    |> map_error(&Error.parse_error(inspect(&1)))
    |> bind(&json_to_wallets(&1))
  end

  defp parse_response(_, 401), do: error(Error.unauthorized())
  defp parse_response(_, _), do: error(Error.server_error())

  @spec json_to_wallets(%{data: [map()]}) ::
          {:ok, [CryptoWallet.t()]} | {:error, Error.t()}
  defp json_to_wallets(%{data: data}), do: map_while_success(data, &data_to_wallet(&1))

  @spec data_to_wallet(%{
          type: String.t(),
          id: String.t(),
          attributes: %{
            cryptocoin_id: String.t(),
            cryptocoin_symbol: String.t(),
            balance: String.t(),
            is_default: boolean(),
            name: String.t(),
            pending_transactions_count: integer(),
            deleted: boolean()
          }
        }) ::
          {:ok, CryptoWallet.t()} | {:error, Error.t()}
  defp data_to_wallet(%{
         type: "wallet",
         id: id,
         attributes: %{
           cryptocoin_id: cryptocoin_id,
           cryptocoin_symbol: cryptocoin_symbol,
           balance: balance,
           is_default: is_default,
           name: name,
           pending_transactions_count: pending_transactions_count,
           deleted: deleted
         }
       }) do
    ok(%CryptoWallet{
      balance: Utils.decimal!(balance),
      cryptocoin_id: cryptocoin_id,
      deleted: deleted,
      id: id,
      is_default: is_default,
      name: name,
      pending_transactions_count: pending_transactions_count,
      symbol: cryptocoin_symbol
    })
  catch
    error ->
      error(Error.parse_error(inspect(error)))
  end

  defp data_to_wallet(_), do: error(Error.parse_error("bad wallet attributes"))
end
