defmodule SealasApi.Accounting.Invoice do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias SealasApi.Repo
  alias SealasApi.Accounting.Invoice
  alias SealasApi.Accounting.InvoiceCategory
  alias SealasApi.Accounting.InvoicePaymentView
  alias SealasApi.Accounting.ContactView

  schema "invoice" do
    belongs_to :contact,          ContactView
    belongs_to :invoice_category, InvoiceCategory
    has_many   :invoice_payment,  InvoicePaymentView

    field :company_data, :string
    field :contact_data, :string
    field :data,         :string
    field :line_data,    :string
    field :log_data,     :string
    field :status,       :binary
    field :type,         :binary
  end

  @doc false
  def changeset(%Invoice{} = invoice, attrs) do
    invoice
    |> cast(attrs, [:data, :contact_data, :line_data, :log_data, :company_data, :type, :status])
  end

  def list do
    Repo.all(Invoice)
  end

  def get!(id), do: Repo.get!(Invoice, id)

  def create(attrs \\ %{}) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  def delete(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end
end
