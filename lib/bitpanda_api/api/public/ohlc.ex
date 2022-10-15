defmodule BitpandaApi.Api.Public.Ohlc do
  @moduledoc """
  Functions to fetch OHLC for a certain asset or many assets
  """

  import Brex.Result.Base
  import Brex.Result.Helpers
  import Brex.Result.Mappers

  alias BitpandaApi.Entity.Ohlc
  alias BitpandaApi.Api.Error
  alias BitpandaApi.Utils
  alias Decimal

  @doc """
  Get OHLC data for all the provided assets for the provided period
  """
  @spec get([String.t()] | String.t(), Ohlc.period()) ::
          {:ok, [Ohlc.t()]} | {:ok, Ohlc.t()} | {:error, Error.t()}

  def get(symbols, period) when is_list(symbols) do
    symbols
    |> Enum.join(",")
    |> url(period)
    |> HTTPoison.get()
    |> map_error(&Error.http_error(&1))
    |> bind(&parse_response(Map.get(&1, :body), Map.get(&1, :status_code), period, symbols))
  end

  def get(symbol, period) do
    [symbol]
    |> get(period)
    |> bind(
      &case List.first(&1) do
        nil ->
          error(Error.no_such_asset(symbol))

        ohlc ->
          ok(ohlc)
      end
    )
  end

  @doc """
  Get OHLC for one or more assets for the provided period.
  Raises an exception on error
  """
  @spec get!([String.t()] | String.t(), Ohlc.period()) :: [Ohlc.t()] | Ohlc.t()
  def get!(symbols, period) do
    symbols
    |> get(period)
    |> extract!()
  end

  @spec parse_response(
          String.t(),
          integer(),
          Ohlc.period(),
          [String.t()]
        ) ::
          {:ok, [Ohlc.t()]} | {:error, Error.t()}

  defp parse_response(body, 200, period, symbols) do
    body
    |> Poison.decode()
    |> map_error(&Error.parse_error(inspect(&1)))
    |> bind(&iter_symbols_in_response(symbols, &1, period))
  end

  defp parse_response(_, _, _, _), do: error(Error.server_error())

  @spec iter_symbols_in_response([String.t()], %{data: [map()]}, Ohlc.period()) ::
          {:ok, [Ohlc.t()]} | {:error, Error.t()}
  defp iter_symbols_in_response(symbols, %{"data" => []}, _),
    do: {:error, Error.no_such_asset(inspect(symbols))}

  defp iter_symbols_in_response(symbols, %{"data" => data}, period) do
    map_while_success(symbols, &symbol_data_to_ohlc(&1, Map.get(data, &1), period))
  end

  @spec symbol_data_to_ohlc(String.t(), [map()] | nil, Ohlc.period()) ::
          {:ok, [Ohlc.t()]} | {:error, Error.t()}
  defp symbol_data_to_ohlc(symbol, nil, _), do: {:error, Error.no_such_asset(symbol)}

  defp symbol_data_to_ohlc(symbol, entries, period) do
    entries
    |> reduce_while_success([], fn entry, acc ->
      entry
      |> data_to_ohlc_entry()
      |> fmap(&Enum.concat(acc, [&1]))
    end)
    |> fmap(
      &%Ohlc{
        symbol: symbol,
        chart: &1,
        period: period
      }
    )
  end

  @spec data_to_ohlc_entry(map()) :: {:ok, Ohlc.entry()} | {:error, Error.t()}
  defp data_to_ohlc_entry(%{
         "type" => "candle",
         "attributes" => %{
           "open" => open,
           "high" => high,
           "close" => close,
           "low" => low,
           "time" => %{
             "date_iso8601" => date_iso8601
           }
         }
       }) do
    ok(%{
      close: Utils.decimal!(close),
      high: Utils.decimal!(high),
      low: Utils.decimal!(low),
      open: Utils.decimal!(open),
      time: Utils.datetime!(date_iso8601)
    })
  catch
    error ->
      error(Error.parse_error(inspect(error)))
  end

  defp data_to_ohlc_entry(data),
    do: error(Error.parse_error("invalid data for chart entry: #{inspect(data)}"))

  @spec url(String.t(), Ohlc.period()) :: String.t()
  defp url(symbols, period),
    do: "https://api.bitpanda.com/v2/ohlc/eur/#{url_period(period)}?assets=#{symbols}"

  @spec url_period(Ohlc.period()) :: String.t()
  defp url_period(:day), do: "day"
  defp url_period(:week), do: "week"
  defp url_period(:month), do: "month"
  defp url_period(:year), do: "year"
end
