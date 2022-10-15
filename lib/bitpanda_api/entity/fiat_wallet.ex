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
          symbol: String.t()
        }
end
