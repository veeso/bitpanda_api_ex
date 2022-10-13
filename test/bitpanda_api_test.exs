defmodule BitpandaApiTest do
  use ExUnit.Case
  doctest BitpandaApi

  test "greets the world" do
    assert BitpandaApi.hello() == :world
  end
end
