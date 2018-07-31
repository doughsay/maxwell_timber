defmodule MaxwellTimber.Mixfile do
  use Mix.Project

  def project do
    [
      app: :maxwell_timber,
      version: "0.5.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ],
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp description do
    """
    Maxwell middleware for logging outgoing requests to Timer.io.

    Using this middleware will automatically log all outgoing requests made with
    maxwell to Timber.io using the correct Timber Events.
    """
  end

  defp package do
    [
      maintainers: ["Chris Dosé <chris.dose@gmail.com>"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/doughsay/maxwell_timber"
      }
    ]
  end

  defp deps do
    [
      {:credo, "~> 0.9", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.6", only: :test},
      {:maxwell, ">= 2.2.0"},
      {:timber, "~> 2.5"}
    ]
  end
end
