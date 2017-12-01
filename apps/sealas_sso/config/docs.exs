use Mix.Config

config :sealas_sso, SealasSso.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres
