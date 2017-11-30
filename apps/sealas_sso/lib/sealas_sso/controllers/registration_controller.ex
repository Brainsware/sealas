defmodule SealasSso.RegistrationController do
  use SealasSso, :controller

  alias SealasSso.Accounts.User

  action_fallback SealasSso.FallbackController

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
