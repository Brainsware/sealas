ExUnit.configure(exclude: [external: true])

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(SealasSso.Repo, :manual)
