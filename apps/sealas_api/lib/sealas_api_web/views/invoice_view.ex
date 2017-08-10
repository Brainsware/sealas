defmodule SealasApiWeb.InvoiceView do
  use SealasApi, :view
  alias SealasApiWeb.InvoiceView

  def render("index.json", %{invoice: invoice}) do
    %{data: render_many(invoice, InvoiceView, "invoice.json")}
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
