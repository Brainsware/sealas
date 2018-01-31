defmodule SealasSso.Mixfile do
  use Mix.Project

  def project do
    [
      app: :sealas_sso,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SealasSso.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:phoenix_html, "~> 2.10"},
      {:gettext, "~> 0.14"},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:argon2_elixir, "~> 1.2.14"},
      {:yubico, "~> 0.1"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.1"},
      {:inch_ex, only: :docs},
      {:base_model, "~> 0.2"},
      {:swoosh, "~> 0.13"},
      {:phoenix_swoosh, "~> 0.2"},
      {:gen_smtp, "~> 0.12"},
      {:jose, "~> 1.8"},
      {:authtoken, "~> 0.2"},

      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.18", only: :dev}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["test": ["ecto.migrate", "test"]]
  end
end
