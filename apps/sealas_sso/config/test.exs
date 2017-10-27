use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sealas_sso, SealasSso.Endpoint,
  http: [port: 4002],
  server: false

config :argon2_elixir,
  t_cost: 2,
  m_cost: 12

config :sealas_sso, SealasSso.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  username: "sealas",
  password: "sealas",
  database: "sealas",
  hostname: "localhost",
  pool_size: 10
