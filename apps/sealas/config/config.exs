use Mix.Config

config :sealas, ecto_repos: [Sealas.Repo]

import_config "#{Mix.env}.exs"
