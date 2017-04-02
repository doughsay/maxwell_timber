defmodule MaxwellTimber.Mixfile do
  use Mix.Project

  def project do
    [app: :maxwell_timber,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:maxwell, ">= 2.2.0"},
     {:timber, ">= 1.1.0"}]
  end

  defp description do
    """
    Maxwell middleware for logging outgoing requests to Timer.io.

    Using this middleware will automatically log all outgoing requests made with
    maxwell to Timber.io using the correct Timber Events.
    """
  end

  defp package do
    [maintainers: ["Chris Dosé <chris.dose@gmail.com>"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/doughsay/maxwell_timber"}]
  end
end
