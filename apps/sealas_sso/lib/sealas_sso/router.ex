defmodule SealasSso.Router do
  use SealasSso, :router
  alias Plug.Conn

  @doc "Minimum request time in µs"
  @minimum_request_time 200_000

  pipeline :api do
    plug :accepts, ["json"]
    plug :request_timer
  end

  pipeline :auth do
    plug :check_token
  end

  scope "/", SealasSso do
    pipe_through :api

    resources "/auth", AuthController
  end

  scope "/user", SealasSso do
    pipe_through :api
    pipe_through :auth

    resources "/", UserController
  end

  def request_timer(conn, _options) do
    time = Time.utc_now()

    Conn.register_before_send(conn, fn conn ->
      diff = Time.diff(Time.utc_now(), time, :microsecond)

      if diff < @minimum_request_time, do: :timer.sleep round((@minimum_request_time - diff)/1000)
      conn
    end)
  end

  def check_token(conn, _options) do
    token = conn |> get_req_header("authorization")

    case decrypt_token(List.first(token)) do
      {:error} ->
        conn
          |> put_status(:unauthorized)
          |> render(SealasSso.ErrorView, "401.json")
          |> halt
      _ ->
        conn
    end
  end

  def decrypt_token(auth_token) when is_binary(auth_token) do
    auth_token = List.last(Regex.run(~r/(bearer\: )?(.+)/, auth_token))

    key = Application.get_env(:sealas_sso, SealasSso.Endpoint)[:token_key]

    jwk = %{"kty" => "oct", "k" => :base64url.encode(key)}

    case JOSE.JWT.verify(jwk, {%{alg: :jose_jws_alg_hmac}, auth_token}) do
      {true, token, _signature} ->
        {:ok, token}
      _ ->
        {:error}
    end
  end

  def decrypt_token(_) do
    {:error}
  end
end
