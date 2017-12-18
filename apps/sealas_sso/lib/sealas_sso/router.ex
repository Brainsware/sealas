defmodule SealasSso.Router do
  use SealasSso, :router
  alias Plug.Conn

  import AuthToken

  @doc "Minimum request time in µs"
  @minimum_request_time 200_000

  @doc """
  Default SSO pipeline: accept requests in JSON format
  All requests to SSO are delayed to take roughly @minimum_request_time to prevent timing attacks.
  """
  pipeline :api do
    plug :accepts, ["json"]
    plug :request_timer, @minimum_request_time
  end

  @doc """
  Pipeline for restricted routes, checks access token
  """
  pipeline :auth do
    plug :check_token
  end

  scope "/", SealasSso do
    pipe_through :api

    get  "/auth", AuthController, :index
    post "/registration", RegistrationController, :create
  end

  scope "/user", SealasSso do
    pipe_through :api
    pipe_through :auth

    resources "/", UserController
  end

  @doc """
  Registers a function to check time used to handle request.
  Subtracts time taken from @minimum_request_time and waits for $result ms
  """
  @spec request_timer(Plug.Conn.t, integer) :: Plug.Conn.t
  def request_timer(conn, minimum_request_time \\ 200_000) do
    time = Time.utc_now()

    Conn.register_before_send(conn, fn conn ->
      diff = Time.diff(Time.utc_now(), time, :microsecond)

      if diff < minimum_request_time, do: :timer.sleep round((minimum_request_time - diff)/1000)
      conn
    end)
  end
end
