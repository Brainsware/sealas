# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sealas,
  ecto_repos: [Sealas.Repo]

# Configures the endpoint
config :sealas, SealasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lI+1C2ahcWCEm6A8hZKmJvmP3E+fNfBYDbfU77p2L+OOc1O3v48xzdQcoh7FGg/S",
  render_errors: [view: SealasWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Sealas.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
