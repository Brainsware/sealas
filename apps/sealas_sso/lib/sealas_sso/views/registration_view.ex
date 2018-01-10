defmodule SealasSso.RegistrationView do
  use SealasSso, :view

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("code.json", %{email: email}) do
    %{email: email}
  end

  def render("retry.json", %{activation_code: activation_code}) do
    %{error: "retry_validation", activation_code: activation_code}
  end

  def render("registration.json", %{activation_code: activation_code}) do
    %{activation_code: activation_code}
  end
end
