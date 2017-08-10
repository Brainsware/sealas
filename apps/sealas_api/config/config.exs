# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sealas_api,
  namespace: SealasApi,
  ecto_repos: [SealasApi.Repo]

# Configures the endpoint
config :sealas_api, SealasApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+AjBy7hh2l8KkaDiGezFQGwpumaDodWi4oqypKU64loxB+Ei1UXodwiNAdvMOXub",
  render_errors: [view: SealasApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SealasApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :sealas_api, :generators,
  context_app: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
