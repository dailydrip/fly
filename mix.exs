defmodule Fly.Mixfile do
  use Mix.Project
  @version "0.1.4"

  def project do
    [
      app: :fly,
      description: description(),
      package: package(),
      version: @version,
      elixir: "~> 1.3",
      deps: deps(),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,

      # Docs config
      name: "Fly",
      source_url: "https://github.com/dailydrip/fly",
      homepage_url: "https://www.dailydrip.com",
      docs: docs(),
    ]
  end

  def application do
    [
      applications: applications(Mix.env),
      mod: {Fly, []}
    ]
  end

  defp applications(:test) do
    applications(:prod) ++ [:dbg]
  end
  defp applications(:dev) do
    applications(:prod) ++ [:dbg]
  end
  defp applications(_) do
    [
      :logger,
      :porcelain,
      :plug,
      :hackney,
      :lru_cache,
    ]
  end

  defp deps do
    [
      {:porcelain, "~> 2.0.3"},
      {:plug, "~> 1.3.0"},
      {:tesla, "~> 0.5.0"},
      {:hackney, "~> 1.6.3"},
      {:lru_cache, "~> 0.1.1"},

      # Docs dependencies
      {:ex_doc, "~> 0.14", only: [:docs, :dev]},
      {:inch_ex, "~> 0.5", only: [:docs, :dev, :test]},

      # Dev + Test dependencies
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:dbg, "~> 1.0", only: [:dev, :test]},
    ]
  end

  defp description do
    """
    An OTP application for on-the-fly file processing, from
    [DailyDrip](https://www.dailydrip.com).
    """
  end

  defp package do
    [
      name: :fly,
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Josh Adams"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "http://github.com/dailydrip/fly"
      }
    ]
  end

  defp docs do
    [
      main: "readme", # The main page in the docs
      logo: "assets/dailydrip_white.png",
      extras: ["README.md"],
    ]
  end
end
