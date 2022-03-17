defmodule Inspecto.MixProject do
  use Mix.Project

  @version "0.1.0"

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
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1.0", only: [:dev], runtime: false},
      {:ecto, "~> 3.7.1"},
      {:ex_doc, "~> 0.28", runtime: false}
    ]
  end

  defp description,
    do: """
    Inspecto (Inspect + Ecto) is a utility to help inspect and summarize your
    Ecto schemas, giving you an overview of the shape of your database.
    """

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
      package: package(),
      test_coverage: [
        tool: ExCoveralls
      ],
      version: "0.1.0",
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
