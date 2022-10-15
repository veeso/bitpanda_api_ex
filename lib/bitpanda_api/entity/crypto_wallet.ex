defmodule BitpandaApi.Entity.CryptoWallet do
  @moduledoc """
  This entity defines a user's crypto wallet
  """

  alias Decimal

  defstruct [
    :balance,
    :cryptocoin_id,
    :deleted,
    :id,
    :is_default,
    :name,
    :pending_transactions_count,
    :symbol
  ]

  @typedoc """
  Defines a crypto wallet
  """
  @type t :: %__MODULE__{
          balance: Decimal.t(),
          cryptocoin_id: String.t(),
          deleted: boolean(),
          id: String.t(),
          is_default: boolean(),
          name: String.t(),
          pending_transactions_count: integer(),
          symbol: String.t()
        }
end
