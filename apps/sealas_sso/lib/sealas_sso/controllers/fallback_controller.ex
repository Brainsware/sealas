defmodule SealasSso.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use SealasSso, :controller

  @spec call(Plug.Conn.t, {:error, Ecto.Changeset}) :: Plug.Conn.t
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(SealasSso.ChangesetView, "error.json", changeset: changeset)
  end

  @doc """
  specialized call/2 for :not_found errors
  """
  @spec call(Plug.Conn.t, {:error, :not_found}) :: Plug.Conn.t
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(SealasSso.ErrorView, :"404", %{})
  end
end
