use Mix.Config

# Configure your database
config :sealas, Sealas.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "sealas_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
