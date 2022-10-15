defmodule BitpandaApi do
  @moduledoc """
  Documentation for `BitpandaApi`.
  """

  @user_api_url "https://api.bitpanda.com/v1"

  @doc """
  Returns user api url
  """
  @spec user_api_url() :: String.t()
  def user_api_url(), do: @user_api_url

  @doc """
  Get library version
  """
  @spec version() :: String.t()
  def version do
    "0.1.0"
  end
end
