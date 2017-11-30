defmodule SealasSso.AuthView do
  use SealasSso, :view

  def render("error.json", _params) do
    %{error: "auth fail"}
  end

  def render("retry.json", %{activation_code: activation_code}) do
    %{error: "retry_validation", activation_code: activation_code}
  end

  def render("tfa.json", %{tfa: tfa}) do
    %{tfa: true, code: tfa}
  end

  def render("auth.json", %{auth: auth}) do
    %{auth: auth}
  end
end
