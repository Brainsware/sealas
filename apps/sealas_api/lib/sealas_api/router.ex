defmodule SealasApi.Router do
  use SealasApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SealasApi do
    pipe_through :api

    resources "/invoices", InvoiceController
    resources "/contacts", ContactController
  end
end
