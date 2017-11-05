defmodule SealasApi.InvoiceController do
  use SealasApi, :controller

  alias SealasApi.Accounting.Invoice

  action_fallback SealasApi.FallbackController

  def index(conn, params \\ %{}) do
    page = Invoice.list(params)
    render conn, "index.json",
      invoice: page.entries,
      page_number: page.page_number,
      total_pages: page.total_pages
  end

  def create(conn, %{"invoice" => invoice_params}) do
    with {:ok, %Invoice{} = invoice} <- Invoice.create(invoice_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", invoice_path(conn, :show, invoice))
      |> render("show.json", invoice: invoice)
    end
  end

  def show(conn, %{"id" => id}) do
    invoice = Invoice.get!(id)
    render(conn, "show.json", invoice: invoice)
  end

  def update(conn, %{"id" => id, "invoice" => invoice_params}) do
    invoice = Invoice.get!(id)

    with {:ok, %Invoice{} = invoice} <- Invoice.update(invoice, invoice_params) do
      render(conn, "show.json", invoice: invoice)
    end
  end

  def delete(conn, %{"id" => id}) do
    invoice = Invoice.get!(id)
    with {:ok, %Invoice{}} <- Invoice.delete(invoice) do
      send_resp(conn, :no_content, "")
    end
  end
end
