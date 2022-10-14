defmodule BitpandaApi.Entity.Trade do
  @moduledoc """
  Bitpanda Trade entity
  """

  alias Decimal

  @typedoc """
  Trade type
  """
  @type type ::
          :buy
          | :sell

  @typedoc """
  A bitpanda Trade
  """
  @type t :: %{
          amount_asset: Decimal.t(),
          amount_fiat: Decimal.t(),
          datetime: DateTime.t(),
          fiat_to_eur_rate: Decimal.t(),
          id_asset: String.t(),
          id_fiat: String.t(),
          id_wallet: String.t(),
          id: String.t(),
          price: Decimal.t(),
          related_swap_trade: t() | nil,
          status: String.t(),
          symbol: String.t(),
          type: type()
        }
end

"""
{
  "type": "trade",
  "attributes": {
    "status": "finished",
    "type": "sell",
    "cryptocoin_id": "116",
    "cryptocoin_symbol": "S&P500",
    "fiat_id": "1",
    "amount_fiat": "189.78",
    "amount_cryptocoin": "5.14609822",
    "fiat_to_eur_rate": "1.00000000",
    "wallet_id": "6ebab8f0-1119-4d07-9bf1-*************",
    "fiat_wallet_id": "41b3a0b8-e847-4097-a4c6-*************",
    "time": {
      "date_iso8601": "2022-10-08T13:33:02+02:00",
      "unix": "1665228782"
    },
    "premium": "0.67",
    "price": "36.88",
    "is_swap": true,
    "is_savings": false,
    "related_swap_trade": {
      "type": "trade",
      "attributes": {
        "status": "finished",
        "type": "buy",
        "cryptocoin_id": "92",
        "cryptocoin_symbol": "V",
        "fiat_id": "1",
        "amount_fiat": "189.78",
        "amount_cryptocoin": "1.00000000",
        "fiat_to_eur_rate": "1.00000000",
        "wallet_id": "ea8986cb-5c09-44c8-9e8d-*************",
        "fiat_wallet_id": "41b3a0b8-e847-4097-a4c6-*************",
        "payment_option_id": "12",
        "time": {
          "date_iso8601": "2022-10-08T13:33:02+02:00",
          "unix": "1665228782"
        },
        "premium": "0.67",
        "price": "189.78",
        "is_swap": true,
        "is_savings": false,
        "related_swap_trade_id": "de95600b-f012-46ec-8237-*************",
        "tags": [],
        "bfc_used": false,
        "is_card": false
      },
      "id": "7b10522a-d952-4c62-ab48-*************"
    },
    "tags": [],
    "bfc_used": false,
    "is_card": false
  },
  "id": "de95600b-f012-46ec-8237-*************"
}
"""
