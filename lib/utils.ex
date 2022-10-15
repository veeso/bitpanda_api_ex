defmodule BitpandaApi.Utils do
  @moduledoc """
  Bitpanda API utilities
  """

  alias Decimal

  @doc """
  A brute decimal parser.

  ## Examples

    iex> decimal!("30.56")
    {:stocazzo}
  """
  @spec decimal!(String.t()) :: Decimal.t()
  def decimal!(value) do
    with {decimal, _} <- Decimal.parse(value) do
      decimal
    end
  end

  @doc """
  Parse IS08601 datetime brutally

  ## Examples

    iex> datetime!("2022-10-15T03:23:22Z")
    ~U[2022-10-15T03:23:22Z]
  """
  @spec datetime!(String.t()) :: DateTime.t()
  def datetime!(value) do
    with {:ok, datetime, _} <- DateTime.from_iso8601(value) do
      datetime
    end
  end
end
