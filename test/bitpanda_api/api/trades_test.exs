defmodule BitpandaApi.Api.TradesTest do
  use ExUnit.Case
  doctest BitpandaApi

  alias BitpandaApi.Api.Trades

  @apikey System.get_env("BITPANDA_APIKEY")

  test "should collect user's trades" do
    assert match?({:ok, _}, Trades.get(@apikey))
  end

  test "should collect user's trades (buy)" do
    assert match?({:ok, _}, Trades.get(@apikey, :buy))
  end

  test "should collect user's trades (sell)" do
    assert match?({:ok, _}, Trades.get(@apikey, :sell))
  end

  test "should not collect user's trades" do
    assert match?({:error, _}, Trades.get("pippo"))
  end
end
