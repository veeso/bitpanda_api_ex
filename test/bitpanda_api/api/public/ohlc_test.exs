defmodule BitpandaApi.Api.Public.OhlcTest do
  use ExUnit.Case
  doctest BitpandaApi

  alias BitpandaApi.Api.Public.Ohlc

  test "should collect OHLC for one asset for a year withour result" do
    assert match?(
             _,
             Ohlc.get!("AMZN", :year)
           )
  end

  test "should collect OHLC for one asset for a year" do
    assert match?(
             {:ok, _},
             Ohlc.get("AMZN", :year)
           )
  end

  test "should collect OHLC for one asset for a month" do
    assert match?(
             {:ok, _},
             Ohlc.get("AMZN", :month)
           )
  end

  test "should collect OHLC for one asset for a week" do
    assert match?(
             {:ok, _},
             Ohlc.get("AMZN", :week)
           )
  end

  test "should collect OHLC for one asset for a day" do
    assert match?(
             {:ok, _},
             Ohlc.get("AMZN", :day)
           )
  end

  test "should collect OHLC for many assets" do
    assert match?(
             {:ok, [_, _, _]},
             Ohlc.get(["AMZN", "BTC", "TSLA"], :week)
           )
  end

  test "should fail to collect OHLC for unexisting asset" do
    assert match?({:error, _}, Ohlc.get("AKOIONE", :year))
  end

  test "should fail to collect OHLC when unexisting asset in list" do
    assert match?({:error, _}, Ohlc.get(["AMZN", "TSLA", "AKOIONE"], :year))
  end
end
