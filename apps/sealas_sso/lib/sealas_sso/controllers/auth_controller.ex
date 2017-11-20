defmodule SealasSso.AuthController do
  use SealasSso, :controller

  alias SealasSso.Accounts
  alias SealasSso.Accounts.User
  alias SealasSso.Repo

  import Comeonin.Argon2

  action_fallback SealasSso.FallbackController

  def index(conn, %{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: email)

    cond do
      user && checkpw(password, user.password) ->
        # generate session
        conn
        |> put_status(:created) # http 201
        |> render("auth.json", %{auth: SealasSso.AuthController.generate_token(conn, user)})
      true ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json")
    end
  end

  def generate_token(conn, user) do
    key = Application.get_env(:sealas_sso, SealasSso.Endpoint)[:token_key]

    jwk = %{"kty" => "oct", "k" => :base64url.encode(key)}
    jws = %{"alg" => "HS256"}

    token_content = %{created_at: DateTime.to_unix(DateTime.utc_now()), id: user.id}

    {%{alg: :jose_jws_alg_hmac}, token} = JOSE.JWS.compact JOSE.JWT.sign(jwk, jws, token_content)

    token
  end
end
