defmodule BitpandaApi.Api.FiatWallet.TransactionsTest do
  use ExUnit.Case
  doctest BitpandaApi

  alias BitpandaApi.Api.FiatWallet.Transactions

  @apikey System.get_env("BITPANDA_APIKEY")

  test "should collect user's fiat wallet's trades" do
    assert match?({:ok, _}, Transactions.get(@apikey))
  end

  test "should collect user's fiat wallet's trades (buy)" do
    assert match?({:ok, _}, Transactions.get(@apikey, :buy))
  end

  test "should collect user's fiat wallet's canceled" do
    assert match?({:ok, _}, Transactions.get(@apikey, nil, :canceled))
  end

  test "should not collect user's trades" do
    assert match?({:error, _}, Transactions.get("pippo"))
  end
end
