defmodule SealasWeb.PageController do
  use SealasWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
