defmodule SealasSso.AuthController do
  use SealasSso, :controller

  alias SealasSso.Accounts.User
  alias SealasSso.Accounts.UserTfa
  alias SealasSso.Repo

  import Comeonin.Argon2

  action_fallback SealasSso.FallbackController

  @spec index(Plug.Conn.t, %{"email" => String.t, "password" => String.t}) :: Plug.Conn.t
  def index(conn, %{"email" => email, "password" => password}) do
    user = User.first(email: email)
    user = Repo.preload(user, :user_tfa)

    cond do
      user && checkpw(password, user.password) && user.user_tfa() != [] ->
        code = User.create_random_password()
        User.update(user, recovery_code: code)

        conn
        |> put_status(:created) # http 201
        |> render("tfa.json", %{tfa: code})
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

  @spec index(Plug.Conn.t, %{"code" => String.t, "auth_key" => String.t}) :: Plug.Conn.t
  def index(conn, %{"code" => code, "auth_key" => auth_key}) do
    user         = User.first(recovery_code: code)
    key          = UserTfa.extract_yubikey(auth_key)
    usertfa      = UserTfa.first(auth_key: key)

    cond do
      {:auth, :ok} == UserTfa.validate_yubikey(auth_key) &&
      {:ok}        == tfa_match(user, usertfa)   ->
        User.update(user, recovery_code: nil)

        conn
        |> put_status(:created) # http 201
        |> render("auth.json", %{auth: generate_token(user)})
      true ->
        conn
        |> put_status(:unauthorized) # http 401
        |> render("error.json")
    end
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- User.create(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  @spec tfa_match(%User{}, %UserTfa{}) :: {}
  defp tfa_match(user, usertfa) do
    cond do
      user && usertfa && user.id == usertfa.user_id ->
        {:ok}
      true ->
        {:error}
    end
  end

  @spec generate_token(%User{}) :: String.t
  defp generate_token(user) do
    key = Application.get_env(:sealas_sso, SealasSso.Endpoint)[:token_key]

    jwk = %{"kty" => "oct", "k" => :base64url.encode(key)}
    jws = %{"alg" => "HS256"}

    token_content = %{created_at: DateTime.to_unix(DateTime.utc_now()), id: user.id}

    {%{alg: :jose_jws_alg_hmac}, token} = JOSE.JWS.compact JOSE.JWT.sign(jwk, jws, token_content)

    token
  end
end
