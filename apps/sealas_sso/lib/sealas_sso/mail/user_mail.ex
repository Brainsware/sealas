defmodule SealasSso.UserMail do
  use Phoenix.Swoosh, view: SealasSso.MailView, layout: {SealasSso.LayoutView, :mail}

  defp prepare(user) do
    logo     = Swoosh.Attachment.new("assets/sealas-logo-white-yellow.png", filename: "logo", content_type: "image/png", type: :inline)
    twitter  = Swoosh.Attachment.new("assets/mail-facebook.png", filename: "facebook", content_type: "image/png", type: :inline)
    facebook = Swoosh.Attachment.new("assets/mail-twitter.png", filename: "twitter", content_type: "image/png", type: :inline)
    github   = Swoosh.Attachment.new("assets/mail-github.png", filename: "github", content_type: "image/png", type: :inline)

    new()
    |> to(user.email)
    |> from({"Sealas Support", "support@sealas.at"})
    |> attachment(logo)
    |> attachment(twitter)
    |> attachment(facebook)
    |> attachment(github)
    |> assign(:app_uri, Application.get_env(:sealas_web, SealasWeb.Endpoint)[:app_uri])
  end

  def verification(user) do
    prepare(user)
    |> subject("Is this reality?")
    |> render_body(:verification, user: user)
  end
end
