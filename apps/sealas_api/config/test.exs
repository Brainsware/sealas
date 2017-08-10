use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sealas_api, SealasApi.Endpoint,
  http: [port: 4001],
  server: false
