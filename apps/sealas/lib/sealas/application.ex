defmodule Sealas.Application do
  @moduledoc """
  The Sealas Application Service.

  The sealas system business domain lives in this application.

  Exposes API to clients such as the `SealasWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(Sealas.Repo, []),
    ], strategy: :one_for_one, name: Sealas.Supervisor)
  end
end
