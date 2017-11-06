defmodule SealasApi.InvoiceView do
  use SealasApi, :view
  alias SealasApi.InvoiceView

  def render("index.json", %{invoice: invoice, page_number: page_number, total_pages: total_pages}) do
    %{data: %{invoices:
      render_many(invoice, InvoiceView, "invoice.json"),
      page_number: page_number,
      total_pages: total_pages}}
  end

  def render("show.json", %{invoice: invoice}) do
    %{data: render_one(invoice, InvoiceView, "invoice.json")}
  end

  def render("invoice.json", %{invoice: invoice}) do
    %{id: invoice.id,
      data: invoice.data,
      contact_data: invoice.contact_data,
      line_data: invoice.line_data,
      log_data: invoice.log_data,
      company_data: invoice.company_data,
      type: invoice.type,
      status: invoice.status}
  end
end
