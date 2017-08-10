defmodule SealasApi.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(SealasApi.Endpoint, []),
      supervisor(SealasApi.Repo, [])
      # Start your own worker by calling: SealasApi.Worker.start_link(arg1, arg2, arg3)
      # worker(SealasApi.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SealasApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SealasApi.Endpoint.config_change(changed, removed)
    :ok
  end
end
