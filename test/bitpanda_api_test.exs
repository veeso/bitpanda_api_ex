defmodule BitpandaApiTest do
  use ExUnit.Case
  doctest BitpandaApi

  test "greets the world" do
    assert BitpandaApi.version() == "0.1.0"
  end
end
