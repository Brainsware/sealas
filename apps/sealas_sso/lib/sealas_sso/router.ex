defmodule SealasSso.Router do
  use SealasSso, :router
  alias Plug.Conn

  # Minimum request time in µs
  @minimum_request_time 200_000

  pipeline :api do
    plug :accepts, ["json"]
    plug :request_timer
  end

  scope "/", SealasSso do
    pipe_through :api

    resources "/user", UserController

    resources "/auth", AuthController
  end

  def request_timer(conn, _options) do
    time = Time.utc_now()

    Conn.register_before_send(conn, fn conn ->
      diff = Time.diff(Time.utc_now(), time, :microsecond)

      if diff < @minimum_request_time, do: :timer.sleep round((@minimum_request_time - diff)/1000)
      conn
    end)
  end
end
