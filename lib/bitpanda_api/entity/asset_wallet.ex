defmodule BitpandaApi.Entity.AssetWallet do
  @moduledoc """
  A wallet for a single asset
  """

  alias BitpandaApi.Entity.Asset

  alias Decimal

  defstruct [
    :asset_id,
    :asset_symbol,
    :balance,
    :class,
    :deleted,
    :id,
    :is_default,
    :name
  ]

  @typedoc """
  A wallet for any asset
  """
  @type t :: %__MODULE__{
          asset_id: String.t(),
          asset_symbol: String.t(),
          balance: Decimal.t(),
          class: Asset.class(),
          deleted: boolean(),
          id: String.t(),
          is_default: boolean(),
          name: String.t()
        }
end
