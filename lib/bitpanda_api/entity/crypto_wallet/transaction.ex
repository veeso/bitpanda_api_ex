defmodule BitpandaApi.Entity.CryptoWallet.Transaction do
  @moduledoc """
  This entity defines a transaction in a crypto wallet
  """

  alias Decimal

  defstruct [
    :amount_eur,
    :amount,
    :confirmations,
    :confirmed,
    :cryptocoin_id,
    :current_fiat_amount,
    :current_fiat_id,
    :datetime,
    :fee,
    :id,
    :in_or_out,
    :recipient,
    :related_wallet_transaction_id,
    :related_wallet_id,
    :status,
    :transaction_type,
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
          | :unconfirmed
          | :open_invitation
          | :unconfirmed_transaction_out

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

  @type in_or_out ::
          :incoming
          | :outgoing

  @typedoc """
  Defines a crypto wallet transaction
  """
  @type t :: %__MODULE__{
          amount_eur: Decimal.t(),
          amount: Decimal.t(),
          confirmations: integer(),
          confirmed: boolean(),
          cryptocoin_id: String.t(),
          current_fiat_amount: Decimal.t(),
          current_fiat_id: String.t(),
          datetime: DateTime.t(),
          fee: Decimal.t(),
          id: String.t(),
          in_or_out: in_or_out(),
          recipient: String.t(),
          related_wallet_transaction_id: String.t(),
          related_wallet_id: String.t(),
          status: status(),
          transaction_type: transaction_type(),
          wallet_id: String.t()
        }
end
