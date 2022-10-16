defmodule BitpandaApi.Entity.FiatWallet do
  @moduledoc """
  This entity defines a user's fiat wallet
  """

  alias Decimal

  defstruct [
    :balance,
    :fiat_id,
    :id,
    :name,
    :pending_transactions_count,
    :symbol
  ]

  @typedoc """
  Defines a fiat wallet
  """
  @type t :: %__MODULE__{
          balance: Decimal.t(),
          fiat_id: String.t(),
          id: String.t(),
          name: String.t(),
          pending_transactions_count: integer(),
          symbol: String.t()
        }
end
