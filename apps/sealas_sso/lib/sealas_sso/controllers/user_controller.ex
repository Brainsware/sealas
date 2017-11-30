defmodule SealasSso.UserController do
  use SealasSso, :controller

  alias SealasSso.Accounts
  alias SealasSso.Accounts.User

  action_fallback SealasSso.FallbackController

  def index(conn, _params) do
    render(conn, "index.json", %{users: []})
  end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Accounts.get_user!(id)
  #
  #   with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
  #     render(conn, "show.json", user: user)
  #   end
  # end
end
