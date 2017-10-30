# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :sealas_web,
  namespace: SealasWeb

# Configures the endpoint
config :sealas_web, SealasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jQYHOF4Y7on3Cvg7JjarzoMkSzRaaV3029fq6oO665UhWDlnbcVPcp8V48BsWMs/",
  render_errors: [view: SealasWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SealasWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :sealas_web, :generators,
  context_app: :sealas

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
