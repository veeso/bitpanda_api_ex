defmodule BitpandaApi.Api.AssetsTest do
  use ExUnit.Case
  doctest BitpandaApi

  alias BitpandaApi.Api.Assets

  test "should collect assets by class type stock" do
    {:ok, assets} = Assets.get_by_class(:stock)
    assert length(assets) > 2000

    assert %{
             id: "73",
             name: "Amazon",
             symbol: "AMZN",
             type: :stock
           } == Enum.find(assets, nil, fn i -> i.symbol == "AMZN" end)
  end

  test "should collect assets by class type etf" do
    {:ok, assets} = Assets.get_by_class(:etf)

    assert %{
             id: "119",
             name: "Top 100 US Tech Stocks",
             symbol: "NASDAQ100",
             type: :etf
           } == Enum.find(assets, nil, fn i -> i.symbol == "NASDAQ100" end)
  end

  test "should collect assets by class type cryptocurrency" do
    {:ok, assets} = Assets.get_by_class(:cryptocurrency)

    assert %{
             id: "5",
             name: "Ethereum",
             symbol: "ETH",
             type: :cryptocurrency
           } == Enum.find(assets, nil, fn i -> i.symbol == "ETH" end)
  end

  test "should collect assets by class type metal" do
    {:ok, assets} = Assets.get_by_class(:metal)

    assert %{
             id: "28",
             name: "Gold",
             symbol: "XAU",
             type: :metal
           } == Enum.find(assets, nil, fn i -> i.symbol == "XAU" end)
  end

  test "should collect assets by class type commodity" do
    {:ok, assets} = Assets.get_by_class(:commodity)

    assert %{
             id: "2702",
             name: "Heating Oil",
             symbol: "HEATINGOIL",
             type: :commodity
           } == Enum.find(assets, nil, fn i -> i.symbol == "HEATINGOIL" end)
  end

  test "should collect asset withour result" do
    assets = Assets.get_by_class!(:commodity)

    assert %{
             id: "2702",
             name: "Heating Oil",
             symbol: "HEATINGOIL",
             type: :commodity
           } == Enum.find(assets, nil, fn i -> i.symbol == "HEATINGOIL" end)
  end
end
