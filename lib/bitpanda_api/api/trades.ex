defmodule BitpandaApi.Api.Trades do
  @moduledoc """
  Api call to collect user's trades
  """

  import Brex.Result.Base
  import Brex.Result.Helpers
  import Brex.Result.Mappers

  alias BitpandaApi.Api.Error
  alias BitpandaApi.Entity.Trade
  alias BitpandaApi.Utils
  alias Decimal

  @default_next_url_params "?page=0&page_size=25"

  @type trade_data :: %{
          attributes: %{
            status: String.t(),
            type: String.t(),
            cryptocoin_id: String.t(),
            cryptocoin_symbol: String.t(),
            fiat_id: String.t(),
            amount_fiat: String.t(),
            amount_cryptocoin: String.t(),
            fiat_to_eur_rate: String.t(),
            fiat_wallet_id: String.t(),
            related_swap_trade: trade_data() | nil,
            time: %{date_iso8601: DateTime.t()},
            price: String.t()
          },
          id: String.t(),
          type: String.t()
        }

  @doc """
  Collect trades for user
  """
  @spec get(String.t(), Trade.type() | nil) :: {:ok, [Trade.t()]} | {:error, Error.t()}
  def get(apikey, type \\ nil), do: get_trades([], apikey, type, @default_next_url_params)

  @doc """
  Collect trades for user. Raises exception on error
  """
  @spec get!(String.t(), Trade.type() | nil) :: [Trade.t()]
  def get!(apikey, type \\ nil) do
    apikey
    |> get(type)
    |> extract!()
  end

  @spec get_trades([Trade.t()], String.t(), Trade.type() | nil, String.t()) ::
          {:ok, [Trade.t()]} | {:error, Error.t()}
  defp get_trades(trades, _, _, nil), do: {:ok, trades}

  defp get_trades(trades, apikey, type, next) do
    type
    |> url(next)
    |> HTTPoison.get([{"X-API-KEY", apikey}])
    |> map_error(&Error.http_error(&1))
    |> bind(&process_response(Map.get(&1, :body), Map.get(&1, :status_code)))
    |> bind(fn {new_trades, next_req} ->
      trades
      |> Enum.concat(new_trades)
      |> get_trades(apikey, type, next_req)
    end)
  end

  @spec process_response(String.t(), integer()) ::
          {:ok, {[Trade.t()], String.t() | nil}} | {:error, Error.t()}
  defp process_response(_, 401), do: error(Error.unauthorized())

  defp process_response(body, 200) do
    body
    |> Poison.decode(%{keys: :atoms})
    |> map_error(&Error.parse_error(inspect(&1)))
    |> bind(&json_to_trades(&1))
  end

  defp process_response(_, _), do: error(Error.server_error())

  @spec json_to_trades(%{data: [map()], links: map()}) ::
          {:ok, {[Trade.t()], String.t() | nil}} | {:error, Error.t()}
  defp json_to_trades(%{data: data, links: links}) do
    data
    |> map_while_success(&data_to_trade(&1))
    |> fmap(&{&1, Map.get(links, :next)})
  end

  @spec data_to_trade(trade_data() | nil) ::
          {:ok, Trade.t() | nil} | {:error, Error.t()}

  defp data_to_trade(nil), do: ok(nil)

  defp data_to_trade(%{
         attributes:
           %{
             status: status,
             type: type,
             cryptocoin_id: cryptocoin_id,
             cryptocoin_symbol: cryptocoin_symbol,
             fiat_id: fiat_id,
             amount_fiat: amount_fiat,
             amount_cryptocoin: amount_cryptocoin,
             fiat_to_eur_rate: fiat_to_eur_rate,
             fiat_wallet_id: fiat_wallet_id,
             time: %{date_iso8601: date_iso8601},
             price: price
           } = attributes,
         id: id,
         type: "trade"
       }) do
    ok(%Trade{
      amount_asset: Utils.decimal!(amount_cryptocoin),
      amount_fiat: Utils.decimal!(amount_fiat),
      datetime: Utils.datetime!(date_iso8601),
      fiat_to_eur_rate: Utils.decimal!(fiat_to_eur_rate),
      id_asset: cryptocoin_id,
      id_fiat: fiat_id,
      id_wallet: fiat_wallet_id,
      id: id,
      price: Utils.decimal!(price),
      related_swap_trade:
        attributes
        |> Map.get(:related_swap_trade)
        |> data_to_trade()
        |> extract!(),
      status: parse_status(status),
      symbol: cryptocoin_symbol,
      type: parse_type(type)
    })
  catch
    error ->
      error(Error.parse_error(inspect(error)))
  end

  defp data_to_trade(%{type: _}), do: ok(nil)

  defp data_to_trade(_),
    do: error(Error.parse_error("missing attribute in trade data"))

  @spec parse_status(String.t()) :: Trade.status()
  defp parse_status("pending"), do: :pending
  defp parse_status("processing"), do: :processing
  defp parse_status("finished"), do: :finished
  defp parse_status("canceled"), do: :canceled

  @spec parse_type(String.t()) :: Trade.type()
  defp parse_type("buy"), do: :buy
  defp parse_type("sell"), do: :sell

  @spec url(Trade.type() | nil, String.t()) :: String.t()
  defp url(type, next), do: "#{BitpandaApi.user_api_url()}/trades#{next}#{type_url_param(type)}"

  @spec type_url_param(Trade.type() | nil) :: String.t()
  defp type_url_param(:buy), do: "&type=buy"
  defp type_url_param(:sell), do: "&type=sell"
  defp type_url_param(nil), do: ""
end
