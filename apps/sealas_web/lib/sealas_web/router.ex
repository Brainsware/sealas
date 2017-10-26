defmodule SealasWeb.Router do
  use SealasWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :csp_headers
  end

  scope "/", SealasWeb do
    pipe_through :browser # Use the default browser stack

    get "/*path", PageController, :index
  end

  def csp_headers(conn, _options) do
    conn
    |> put_resp_header("x-frame-options", "SAMEORIGIN")
    |> put_resp_header("x-content-type-options", "nosniff")
    |> put_resp_header("referrer-policy", "no-referrer-when-downgrade")
    |> put_resp_header("content-security-policy", "default-src 'self' 'unsafe-inline' 'unsafe-eval' stats.esotericsystems.at " <> Application.get_env(:sealas, SealasWeb.Endpoint)[:static_uri] <> " www.youtube.com youtube.com fonts.googleapis.com fonts.gstatic.com q.stripe.com checkout.stripe.com js.stripe.com api.fixer.io; img-src 'self' data: " <> Application.get_env(:sealas, SealasWeb.Endpoint)[:static_uri] <> " " <> Application.get_env(:sealas, SealasWeb.Endpoint)[:cdn_uri] <> " q.stripe.com stats.esotericsystems.at")
  end
end
