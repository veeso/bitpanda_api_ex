defmodule BitpandaApi.Api.CryptoWalletTest do
  use ExUnit.Case
  doctest BitpandaApi

  alias BitpandaApi.Api.CryptoWallet

  @apikey System.get_env("BITPANDA_APIKEY")

  test "should collect user's cryptowallet" do
    assert match?({:ok, _}, CryptoWallet.get(@apikey))
  end

  test "should not collect user's crypto wallets" do
    assert match?({:error, _}, CryptoWallet.get("pippo"))
  end
end
