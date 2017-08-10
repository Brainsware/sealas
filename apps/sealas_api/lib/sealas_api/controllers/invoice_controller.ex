defmodule SealasApi.InvoiceController do
  use SealasApi, :controller

  alias SealasApi.Accounting
  alias SealasApi.Accounting.Invoice

  action_fallback SealasApi.FallbackController

  def index(conn, _params) do
    invoice = Accounting.list_invoice()
    render(conn, "index.json", invoice: invoice)
  end

  def create(conn, %{"invoice" => invoice_params}) do
    with {:ok, %Invoice{} = invoice} <- Accounting.create_invoice(invoice_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", invoice_path(conn, :show, invoice))
      |> render("show.json", invoice: invoice)
    end
  end

  def show(conn, %{"id" => id}) do
    invoice = Accounting.get_invoice!(id)
    render(conn, "show.json", invoice: invoice)
  end

  def update(conn, %{"id" => id, "invoice" => invoice_params}) do
    invoice = Accounting.get_invoice!(id)

    with {:ok, %Invoice{} = invoice} <- Accounting.update_invoice(invoice, invoice_params) do
      render(conn, "show.json", invoice: invoice)
    end
  end

  def delete(conn, %{"id" => id}) do
    invoice = Accounting.get_invoice!(id)
    with {:ok, %Invoice{}} <- Accounting.delete_invoice(invoice) do
      send_resp(conn, :no_content, "")
    end
  end
end
