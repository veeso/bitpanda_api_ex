defmodule BitpandaApi.Entity.FiatWallet.Transaction do
  @moduledoc """
  This entity defines a transaction in a fiat wallet
  """

  alias Decimal

  defstruct [
    :amount,
    :datetime,
    :fee,
    :fiat_id,
    :in_or_out,
    :status,
    :to_eur_rate,
    :transaction_type,
    :user_id,
    :wallet_id
  ]

  @typedoc """
  Defines the status of a transaction
  """
  @type status ::
          :pending
          | :processing
          | :finished
          | :canceled

  @typedoc """
  Describes the transaction type
  """
  @type transaction_type ::
          :buy
          | :sell
          | :deposit
          | :withdrawal
          | :transfer
          | :refund
          | :ico

  @typedoc """
  Describes the transaction direction
  """
  @type direction ::
          :incoming
          | :outgoing

  @typedoc """
  Defines a crypto wallet transaction
  """
  @type t :: %__MODULE__{
          amount: Decimal.t(),
          datetime: DateTime.t(),
          fee: Decimal.t(),
          fiat_id: String.t(),
          in_or_out: direction(),
          status: status(),
          to_eur_rate: Decimal.t(),
          transaction_type: transaction_type(),
          user_id: String.t(),
          wallet_id: String.t()
        }
end
