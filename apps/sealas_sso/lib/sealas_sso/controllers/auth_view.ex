defmodule SealasSso.AuthView do
  use SealasSso, :view
  alias SealasSso.AuthView

  def render("error.json", _params) do
    %{error: "auth fail"}
  end

  def render("auth.json", %{auth: auth}) do
    %{auth: auth}
  end
end
