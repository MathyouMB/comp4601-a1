defmodule Sentinel.MixProject do
  use Mix.Project

  def project do
    [
      app: :sentinel,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # applications: [:httpoison],
      extra_applications: [:logger, :httpoison],
      mod: {Sentinel.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.4"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.8"}
    ]
  end
end
