defmodule SealasSso.AuthView do
  use SealasSso, :view

  def render("error.json", _params) do
    %{error: "auth fail"}
  end

  def render("tfa.json", %{tfa: tfa}) do
    %{tfa: true, code: tfa}
  end

  def render("auth.json", %{auth: auth}) do
    %{auth: auth}
  end
end
