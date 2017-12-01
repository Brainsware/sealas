use Mix.Config

config :sealas_api, SealasApi.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  adapter: Ecto.Adapters.Postgres
