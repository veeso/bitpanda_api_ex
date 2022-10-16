defmodule BitpandaApi.Api.FiatWalletTest do
  use ExUnit.Case
  doctest BitpandaApi

  alias BitpandaApi.Api.FiatWallet

  @apikey System.get_env("BITPANDA_APIKEY")

  test "should collect user's fiat wallets" do
    assert match?({:ok, _}, FiatWallet.get(@apikey))
  end

  test "should not collect fiat wallets" do
    assert match?({:error, _}, FiatWallet.get("pippo"))
  end
end
