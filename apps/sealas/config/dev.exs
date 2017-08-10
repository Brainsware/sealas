use Mix.Config

config :sealas, Sealas.Endpoint,
  cdn_uri:    "cdn.sealas.at",
  static_uri: "static.sealas.local"

# Configure your database
config :sealas, Sealas.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "1234",
  database: "pirrad_dev",
  hostname: "localhost",
  pool_size: 10
