defmodule BitpandaApi.Entity.Ohlc do
  @moduledoc """
  Open-High-Low-Close chart for asset
  """

  alias Decimal

  @typedoc """
  OHLC chart period
  """
  @type period ::
          :day
          | :week
          | :month
          | :year

  @typedoc """
  Describes a OHLC chart for an asset
  """
  @type t :: %{
          symbol: String.t(),
          chart: [entry()],
          period: period()
        }

  @typedoc """
  A single entry in the OHLC
  """
  @type entry :: %{
          close: Decimal.t(),
          high: Decimal.t(),
          low: Decimal.t(),
          open: Decimal.t(),
          time: DateTime.t()
        }
end
