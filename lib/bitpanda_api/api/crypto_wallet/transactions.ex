defmodule BitpandaApi.Api.CryptoWallet.Transactions do
  @moduledoc """
  Api call to collect crypto wallets transactions
  """

  import Brex.Result.Base
  import Brex.Result.Helpers
  import Brex.Result.Mappers

  alias BitpandaApi.Api.Error
  alias BitpandaApi.Entity.CryptoWallet.Transaction
  alias BitpandaApi.Utils
  alias Decimal

  @default_next_url_params "?page=0&page_size=25"

  @type transaction_data :: %{
          attributes: %{
            amount: String.t(),
            recipient: String.t(),
            time: %{
              date_iso8601: String.t()
            },
            confirmations: integer(),
            in_or_out: String.t(),
            type: String.t(),
            status: String.t(),
            amount_eur: String.t(),
            related_wallet_transaction_id: String.t(),
            related_wallet_id: String.t(),
            wallet_id: String.t(),
            confirmed: boolean(),
            cryptocoin_id: String.t(),
            fee: String.t(),
            current_fiat_id: String.t(),
            current_fiat_amount: String.t()
          },
          id: String.t(),
          type: String.t()
        }

  @doc """
  Collect transactions for user
  """
  @spec get(String.t(), Transaction.transaction_type() | nil, Transaction.status() | nil) ::
          {:ok, [Transaction.t()]} | {:error, Error.t()}
  def get(apikey, type \\ nil, status \\ nil),
    do: get_transactions([], apikey, type, status, @default_next_url_params)

  @doc """
  Collect transactions for user. Raises exception on error
  """
  @spec get!(String.t(), Transaction.type() | nil, Transaction.status() | nil) :: [
          Transaction.t()
        ]
  def get!(apikey, type \\ nil, status \\ nil) do
    apikey
    |> get(type, status)
    |> extract!()
  end

  @spec get_transactions(
          [Transaction.t()],
          String.t(),
          Transaction.type() | nil,
          Transaction.status() | nil,
          String.t()
        ) ::
          {:ok, [Transaction.t()]} | {:error, Error.t()}
  defp get_transactions(trades, _, _, _, nil), do: {:ok, trades}

  defp get_transactions(trades, apikey, type, status, next) do
    type
    |> url(status, next)
    |> HTTPoison.get([{"X-API-KEY", apikey}])
    |> map_error(&Error.http_error(&1))
    |> bind(&process_response(Map.get(&1, :body), Map.get(&1, :status_code)))
    |> bind(fn {new_trades, next_req} ->
      trades
      |> Enum.concat(new_trades)
      |> get_transactions(apikey, type, status, next_req)
    end)
  end

  @spec process_response(String.t(), integer()) ::
          {:ok, {[Transaction.t()], String.t() | nil}} | {:error, Error.t()}
  defp process_response(_, 401), do: error(Error.unauthorized())

  defp process_response(body, 200) do
    body
    |> Poison.decode(%{keys: :atoms})
    |> map_error(&Error.parse_error(inspect(&1)))
    |> bind(&json_to_trades(&1))
  end

  defp process_response(_, _), do: error(Error.server_error())

  @spec json_to_trades(%{data: [map()], links: map()}) ::
          {:ok, {[Transaction.t()], String.t() | nil}} | {:error, Error.t()}
  defp json_to_trades(%{data: data, links: links}) do
    data
    |> map_while_success(&data_to_transaction(&1))
    |> fmap(&{&1, Map.get(links, :next)})
  end

  @spec data_to_transaction(transaction_data() | nil) ::
          {:ok, Transaction.t() | nil} | {:error, Error.t()}

  defp data_to_transaction(nil), do: ok(nil)

  defp data_to_transaction(%{
         attributes: %{
           amount: amount,
           recipient: recipient,
           time: %{
             date_iso8601: date_iso8601
           },
           confirmations: confirmations,
           in_or_out: in_or_out,
           type: type,
           status: status,
           amount_eur: amount_eur,
           related_wallet_transaction_id: related_wallet_transaction_id,
           related_wallet_id: related_wallet_id,
           wallet_id: wallet_id,
           confirmed: confirmed,
           cryptocoin_id: cryptocoin_id,
           fee: fee,
           current_fiat_id: current_fiat_id,
           current_fiat_amount: current_fiat_amount
         },
         id: id,
         type: "transaction"
       }) do
    ok(%Transaction{
      amount: Utils.decimal!(amount),
      amount_eur: Utils.decimal!(amount_eur),
      confirmations: confirmations,
      confirmed: confirmed,
      cryptocoin_id: cryptocoin_id,
      current_fiat_amount: Utils.decimal!(current_fiat_amount),
      current_fiat_id: current_fiat_id,
      datetime: Utils.datetime!(date_iso8601),
      fee: Utils.decimal!(fee),
      id: id,
      in_or_out: parse_direction(in_or_out),
      recipient: recipient,
      related_wallet_transaction_id: related_wallet_transaction_id,
      related_wallet_id: related_wallet_id,
      status: parse_status(status),
      transaction_type: parse_type(type),
      wallet_id: wallet_id
    })
  catch
    error ->
      error(Error.parse_error(inspect(error)))
  end

  defp data_to_transaction(%{type: _}), do: ok(nil)

  defp data_to_transaction(_),
    do: error(Error.parse_error("missing attribute in trade data"))

  @spec parse_direction(String.t()) :: Transaction.in_or_out()
  defp parse_direction("incoming"), do: :incoming
  defp parse_direction("outgoing"), do: :outgoing

  @spec parse_status(String.t()) :: Transaction.status()
  defp parse_status("pending"), do: :pending
  defp parse_status("processing"), do: :processing
  defp parse_status("finished"), do: :finished
  defp parse_status("canceled"), do: :canceled
  defp parse_status("unconfirmed"), do: :unconfirmed
  defp parse_status("open_invitation"), do: :open_invitation
  defp parse_status("unconfirmed_transaction_out"), do: :unconfirmed_transaction_out

  @spec parse_type(String.t()) :: Transaction.type()
  defp parse_type("buy"), do: :buy
  defp parse_type("sell"), do: :sell
  defp parse_type("deposit"), do: :deposit
  defp parse_type("withdrawal"), do: :withdrawal
  defp parse_type("transfer"), do: :transfer
  defp parse_type("refund"), do: :refund
  defp parse_type("ico"), do: :ico

  @spec url(Transaction.transaction_type() | nil, Transaction.status() | nil, String.t()) ::
          String.t()
  defp url(type, status, next),
    do:
      "#{BitpandaApi.user_api_url()}/wallets/transactions#{next}#{type_url_param(type)}#{status_url_param(status)}"

  @spec type_url_param(Transaction.transaction_type() | nil) :: String.t()
  defp type_url_param(nil), do: ""
  defp type_url_param(type), do: "&type=#{Atom.to_string(type)}"

  @spec status_url_param(Transaction.status() | nil) :: String.t()
  defp status_url_param(nil), do: ""
  defp status_url_param(status), do: "&status=#{Atom.to_string(status)}"
end
