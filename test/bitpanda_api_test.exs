defmodule BitpandaApiTest do
  use ExUnit.Case
  doctest BitpandaApi

  test "check version" do
    assert BitpandaApi.version() == "0.1.0"
  end

  test "should get user api url" do
    assert BitpandaApi.user_api_url() == "https://api.bitpanda.com/v1"
  end
end
