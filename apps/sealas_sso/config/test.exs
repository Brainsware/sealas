use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sealas_sso, SealasSso.Endpoint,
  http: [port: 4002],
  server: false

config :sealas_sso, SealasSso.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres,
  username: "sealas",
  password: "sealas",
  database: "sealas",
  hostname: "localhost",
  pool_size: 10

config :argon2_elixir,
  t_cost: 2,
  m_cost: 12

config :sealas_sso, AuthToken,
  token_key: <<9, 220, 102, 230, 103, 242, 149, 254, 4, 33, 137, 240, 23, 90, 99, 250>>

config :sealas_sso, SealasSso.Yubikey,
  skip_server: true

import_config "config.secret.exs"
