defmodule SealasSso.UserMail do
  use Phoenix.Swoosh, view: SealasSso.MailView, layout: {SealasSso.LayoutView, :mail}

  defp prepare(user) do
    mail = new()
    |> to(user.email)
    |> from(Application.get_env(:sealas_sso, SealasSso.Mailer)[:from])
    |> assign(:app_uri,    Application.get_env(:sealas_web, SealasWeb.Endpoint)[:app_uri])
    |> assign(:static_uri, Application.get_env(:sealas_web, SealasWeb.Endpoint)[:static_uri])

    embedded_images = Application.get_env(:sealas_sso, SealasSso.Mailer)[:embedded_images]

    mail = Enum.map(embedded_images, fn {k, v} -> Swoosh.Attachment.new(v, filename: k, content_type: "image/png", type: :inline) end)
    |> images(mail)

    mail
  end

  defp images([head | tail], mail), do: images(tail, attachment(mail, head))
  defp images([], mail), do: mail

  def verification(user) do
    prepare(user)
    |> subject("Is this reality?")
    |> render_body(:verification, user: user)
  end
end
