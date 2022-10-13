defmodule BitpandaApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :bitpanda_api,
      deps: deps(),
      elixir: "~> 1.14",
      homepage_url: "https://github.com/veeso/bitpanda_api_ex",
      name: "Bitpanda API",
      package: package(),
      source_url: "https://github.com/veeso/bitpanda_api_ex",
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:decimal, "~> 2.0"},
      {:httpoison, "~> 1.8"},
      {:poison, "~> 5.0"}
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
