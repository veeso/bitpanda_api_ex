defmodule BitpandaApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :bitpanda_api,
      deps: deps(),
      description: description(),
      elixir: "~> 1.10",
      homepage_url: "https://github.com/veeso/bitpanda_api_ex",
      name: "Bitpanda API",
      package: package(),
      source_url: "https://github.com/veeso/bitpanda_api_ex",
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      version: "0.1.0"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  defp description, do: "Elixir Bitpanda API client"

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:brex_result, "~> 0.4.0"},
      {:decimal, "~> 2.0"},
      {:httpoison, "~> 1.8"},
      {:poison, "~> 5.0"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.15", only: :test}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/veeso/bitpanda_api_ex"},
      name: "bitpanda_api"
    ]
  end
end
