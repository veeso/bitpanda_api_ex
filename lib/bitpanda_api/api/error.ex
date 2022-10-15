defmodule BitpandaApi.Api.Error do
  @moduledoc """
  This module exposes the API Error
  """

  alias HTTPoison.Error, as: HttpError

  defstruct [:type, {:message, nil}]

  @typedoc """
  Api error
  """
  @type t :: %__MODULE__{
          type: type(),
          message: String.t() | nil
        }

  @typedoc """
  Error type
  """
  @type type ::
          :http
          | :parse
          | :no_such_asset
          | :unauthorized
          | :server_error

  @spec http_error(HttpError.t()) :: t()
  def http_error(error), do: %__MODULE__{type: :http, message: inspect(error)}

  @spec parse_error(String.t()) :: t()
  def parse_error(message), do: %__MODULE__{type: :parse, message: message}

  @spec no_such_asset(String.t()) :: t()
  def no_such_asset(symbol),
    do: %__MODULE__{type: :no_such_asset, message: "no such asset with symbol: #{symbol}"}

  @spec unauthorized() :: t()
  def unauthorized, do: %__MODULE__{type: :unauthorized}

  @spec server_error() :: t()
  def server_error, do: %__MODULE__{type: :server_error}
end
