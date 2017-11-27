defmodule SealasSso.AuthController do
  use SealasSso, :controller

  alias SealasSso.Accounts.User
  alias SealasSso.Repo

  import Comeonin.Argon2

  action_fallback SealasSso.FallbackController

  def index(conn, %{"email" => email, "password" => password}) do
    user = User.first(email: email)
    user = Repo.preload(user, :user_tfa)

    cond do
      user && user.user_tfa() != [] ->
        conn
        |> put_status(:created) # http 201
        |> render("tfa.json", %{tfa: 123})
      user && checkpw(password, user.password) ->
        # generate session
        conn
        |> put_status(:created) # http 201
        |> render("auth.json", %{auth: generate_token(user)})
      true ->
        conn
        |> put_status(:unauthorized) # http 401
        |> render("error.json")
    end
  end

  def index(conn, %{"code" => code, "auth_key" => auth_key}) do
    conn
    |> render("error.json")
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- User.create(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end


  defp generate_token(user) do
    key = Application.get_env(:sealas_sso, SealasSso.Endpoint)[:token_key]

    jwk = %{"kty" => "oct", "k" => :base64url.encode(key)}
    jws = %{"alg" => "HS256"}

    token_content = %{created_at: DateTime.to_unix(DateTime.utc_now()), id: user.id}

    {%{alg: :jose_jws_alg_hmac}, token} = JOSE.JWS.compact JOSE.JWT.sign(jwk, jws, token_content)

    token
  end
end
