defmodule Fly.Mixfile do
  use Mix.Project
  @version "0.1.0"

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
    [applications: [:logger, :porcelain],
     mod: {Fly, []}]
  end

  defp deps do
    [
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:porcelain, "~> 2.0.3"},


      # Docs dependencies
      {:ex_doc, "~> 0.14", only: [:docs, :dev]},
      {:inch_ex, "~> 0.5", only: [:docs, :dev, :test]},
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
