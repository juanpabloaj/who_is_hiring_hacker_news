defmodule WhoIsHiring.MixProject do
  use Mix.Project

  def project do
    [
      app: :who_is_hiring,
      version: "0.2.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: releases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WhoIsHiring.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.0"},
      {:jason, "~> 1.2"},
      {:ecto_sqlite3, "~> 0.10"},
      {:html_entities, "~> 0.5"},
      {:burrito, github: "burrito-elixir/burrito", only: :prod}
    ]
  end

  defp releases do
    [
      who_is_hiring: [
        include_executables_for: [:unix],
        applications: [runtime_tools: :permanent]
      ],
      who_is_hiring_burrito: [
        steps: [:assemble, &Burrito.wrap/1],
        burrito: [
          targets: [
            linux: [os: :linux, cpu: :x86_64]
          ]
        ]
      ]
    ]
  end
end
