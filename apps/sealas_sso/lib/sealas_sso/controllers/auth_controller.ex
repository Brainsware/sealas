defmodule SealasSso.AuthController do
  @moduledoc """
  Controller for all authentication actions:
  Default login, login with TFA, login with OTP and any other future ones.
  """

  use SealasSso, :controller

  alias SealasSso.Accounts.User
  alias SealasSso.Accounts.UserTfa
  alias SealasSso.Repo

  action_fallback SealasSso.FallbackController

  @doc """
  Login entry point for auth with email and password.
  Checks for any set TFA options
  """
  @spec index(Plug.Conn.t, %{email: String.t, password: String.t}) :: Plug.Conn.t
  def index(conn, %{"email" => email, "password" => password}) do
    user = User.first(email: email)
    user = Repo.preload(user, :user_tfa)

    cond do
      # Valid Login with TFA
      user && user.active && EctoHashedPassword.checkpw(password, user.password) && user.user_tfa() != [] ->
        code = User.create_random_password()
        User.update(user, recovery_code: code)

        conn
        |> put_status(:created) # http 201
        |> render("tfa.json", %{tfa: code})

      # Valid Login (no TFA)
      user && user.active && EctoHashedPassword.checkpw(password, user.password) ->
        token_content = %{id: user.id}
        {:ok, token}  = AuthToken.generate_token(token_content)

        conn
        |> put_status(:created) # http 201
        |> render("auth.json", %{auth: token})

      # User exists, needs activation
      user && !user.active ->
        code_hash = :crypto.hash(:sha256, user.activation_code) |> Base.encode16 |> String.downcase

        conn
        |> put_status(:bad_request)
        |> render("retry.json", activation_code: code_hash)

      # invalid login, for which ever reason
      true ->
        conn
        |> put_status(:unauthorized) # http 401
        |> render("error.json")
    end
  end

  @doc """
  Entry for auth with TFA key.
  Requires code to identify user
  """
  @spec index(Plug.Conn.t, %{code: String.t, auth_key: String.t}) :: Plug.Conn.t
  def index(conn, %{"code" => code, "auth_key" => auth_key}) do
    user         = User.first(recovery_code: code)
    key          = UserTfa.extract_yubikey(auth_key)
    usertfa      = UserTfa.first(auth_key: key)

    cond do
      {:auth, :ok} == UserTfa.validate_yubikey(auth_key) &&
      {:ok}        == tfa_match(user, usertfa)   ->
        User.update(user, recovery_code: nil)

        token_content = %{id: user.id}
        {:ok, token}  = AuthToken.generate_token(token_content)

        conn
        |> put_status(:created) # http 201
        |> render("auth.json", %{auth: token})
      true ->
        conn
        |> put_status(:unauthorized) # http 401
        |> render("error.json")
    end
  end

  @doc """
  Refresh stale token
  """
  def index(conn, %{"token" => auth_token}) do
    {:ok, token} = AuthToken.decrypt_token(auth_token)

    user = User.first(id: token["id"])

    {:ok, token} = AuthToken.refresh_token(auth_token)

    cond do
      user && user.active && token ->
        conn
        |> put_status(:created)
        |> render("auth.json", %{auth: token})
      true ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json")
    end
  end

  @doc """
  Checks for valid User and UserTFA entries and checks for a valid TFA key.
  """
  @spec tfa_match(%User{}, %UserTfa{}) :: {:ok} | {:error}
  defp tfa_match(user, usertfa) do
    cond do
      user && usertfa && user.id == usertfa.user_id ->
        {:ok}
      true ->
        {:error}
    end
  end
end
