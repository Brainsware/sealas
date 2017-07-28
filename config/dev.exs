use Mix.Config

config :sealas, SealasWeb.Endpoint,
  cdn_uri:    "cdn.sealas.at",
  static_uri: "static.sealas.local"

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :sealas, SealasWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# Watch static and templates for browser reloading.
config :sealas, SealasWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :sealas, Sealas.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "1234",
  database: "pirrad_dev",
  hostname: "localhost",
  pool_size: 10
