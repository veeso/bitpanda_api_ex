defmodule BitpandaApi.Api.AssetWalletTest do
  use ExUnit.Case
  doctest BitpandaApi

  alias BitpandaApi.Api.AssetWallet

  @apikey System.get_env("BITPANDA_APIKEY")

  test "should collect user's asset wallets" do
    assert match?({:ok, _}, AssetWallet.get(@apikey))
  end

  test "should not collect user's asset wallets" do
    assert match?({:error, _}, AssetWallet.get("pippo"))
  end
end
