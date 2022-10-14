defmodule BitpandaApi.Api.Error do
  @moduledoc """
  This module exposes the API Error
  """

  alias HTTPoison.Error, as: HttpError

  @typedoc """
  Api error
  """
  @type t :: %{
          type: type(),
          message: String.t()
        }

  @typedoc """
  Error type
  """
  @type type ::
          :http
          | :parse
          | :no_such_asset

  @spec http_error(HttpError.t()) :: t()
  def http_error(error), do: %{type: :http, message: inspect(error)}

  @spec parse_error(String.t()) :: t()
  def parse_error(message), do: %{type: :parse, message: message}

  @spec no_such_asset(String.t()) :: t()
  def no_such_asset(symbol),
    do: %{type: :no_such_asset, message: "no such asset with symbol: #{symbol}"}
end
