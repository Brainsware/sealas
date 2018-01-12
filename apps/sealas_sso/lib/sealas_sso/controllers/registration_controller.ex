defmodule SealasSso.RegistrationController do
  @moduledoc """
  Controller for all registration actions, including user verification
  """

  use SealasSso, :controller

  alias SealasSso.Accounts.User

  action_fallback SealasSso.FallbackController

  @spec show(Plug.Conn.T, %{id: String.t}) :: Plug.Conn.t
  def show(conn, %{"id" => code}) do
    user = User.first(activation_code: code)

    cond do
      user && !user.active ->
        conn
        |> render("code.json", email: user.email)
      true ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", error: "wrong_code")
    end
  end

  @spec create(Plug.Conn.T, %{code: String.t, user: %{}}) :: Plug.Conn.t
  def create(conn, %{"code" => code, "user" => user_params}) do
    user = User.first(activation_code: code)

    cond do
      !user || user.active ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", error: "wrong_code")
      true ->
        conn
    end
  end

  @doc """
  First step to registration, check email, create new user with it.

  TODO: Also sends out e-mail with verification code in later version.
  """
  @spec create(Plug.Conn.t, %{user: %{}}) :: Plug.Conn.t
  def create(conn, %{"user" => user_params}) do
    code = User.create_random_password()
    user_params = Enum.into(%{"activation_code" => code}, user_params)

    code_hash = :crypto.hash(:sha256, code) |> Base.encode16 |> String.downcase

    case User.create(user_params) do
      {:ok, %User{} = user} ->
        conn
        |> put_status(:created)
        |> render("registration.json", activation_code: code_hash)
      {:error, changeset} ->
        user = User.first(email: user_params["email"])

        cond do
          # somebody is trying to register with an email that's already registered
          user && !user.active ->
            code_hash = :crypto.hash(:sha256, user.activation_code) |> Base.encode16 |> String.downcase

            conn
            |> put_status(:bad_request)
            |> render("retry.json", activation_code: code_hash)
          true ->
            conn
            |> put_status(:bad_request) # http 400
            |> render("error.json", error: "already_registered")
        end
    end
  end
end
