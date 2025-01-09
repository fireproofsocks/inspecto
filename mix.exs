defmodule Inspecto.MixProject do
  use Mix.Project

  @version "0.4.0"

  @source_url "https://github.com/fireproofsocks/inspecto"

  defp aliases do
    [
      lint: ["format --check-formatted", "credo --strict"]
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
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev], runtime: false},
      {:ecto, "~> 3.12", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.36", runtime: false},
      {:excoveralls, "~> 0.18", only: [:dev, :test], runtime: false}
    ]
  end

  defp description,
    do: """
    Inspecto (Inspect + Ecto) is a utility that helps inspect and summarize your
    Ecto schemas for documentation or other tools that require convenient reflection.
    """

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def links do
    %{
      "GitHub" => @source_url,
      "Readme" => "#{@source_url}/blob/v#{@version}/README.md",
      "Changelog" => "#{@source_url}/blob/v#{@version}/CHANGELOG.md"
    }
  end

  defp package do
    [
      maintainers: ["Everett Griffiths"],
      licenses: ["Apache-2.0"],
      logo: "assets/logo.png",
      links: links(),
      files: [
        "lib",
        "priv",
        "logo.png",
        "mix.exs",
        "README*",
        "CHANGELOG*",
        "LICENSE*"
      ]
    ]
  end

  def project do
    [
      aliases: aliases(),
      app: :inspecto,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      test_coverage: [
        tool: ExCoveralls
      ],
      version: @version,
      docs: [
        source_ref: "v#{@version}",
        logo: "logo.png"
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test
      ]
    ]
  end
end
