defmodule BitpandaApi.Asset do
  @moduledoc """
  Describes an asset listed on Bitpanda
  """

  @typedoc """
  Describes the asset class
  """
  @type class ::
          :commodity
          | :cryptocurrency
          | :etf
          | :metal
          | :stock

  @typedoc """
  An asset in Bitpanda
  """
  @type t :: %{
          id: String.t(),
          name: String.t(),
          symbol: String.t(),
          type: class()
        }
end
