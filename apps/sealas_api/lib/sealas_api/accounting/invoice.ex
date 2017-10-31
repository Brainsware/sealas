defmodule SealasApi.Accounting.Invoice do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias SealasApi.Repo
  alias SealasApi.Accounting.Invoice
  alias SealasApi.Accounting.InvoiceCategory
  alias SealasApi.Accounting.InvoicePayment
  alias SealasApi.Accounting.Contact

  schema "invoice" do
    belongs_to :contact,          Contact
    belongs_to :invoice_category, InvoiceCategory
    has_many   :invoice_payment,  InvoicePayment

    field :company_data, :string
    field :contact_data, :string
    field :data,         :string
    field :line_data,    :string
    field :log_data,     :string
    field :status,       Ecto.UUID
    field :type,         Ecto.UUID
  end

  @doc false
  def changeset(%Invoice{} = invoice, attrs) do
    {:ok, status_uuid} = Ecto.UUID.cast(:crypto.hash(:md5, attrs.status))
    {:ok, type_uuid}   = Ecto.UUID.cast(:crypto.hash(:md5, attrs.type))

    attrs = %{attrs | status: status_uuid, type: type_uuid }

    invoice
    |> cast(attrs, [:data, :contact_data, :line_data, :log_data, :company_data, :status, :type])
  end

  def list do
    Repo.all(Invoice)
  end

  def get!(id), do: Repo.get!(Invoice, id)

  defp get_by_query(type), do: "SELECT * FROM invoice WHERE #{type} = md5($1)::uuid"

  def get_by!(type, value) do
    {:ok, invoices} = Repo.query(get_by_query(type), [value])

    imap = Enum.map(invoices.columns, fn (column) -> String.to_atom(column) end)

    Enum.map(invoices.rows, fn (r) ->
      i = struct(Invoice, Enum.zip(imap, r))
      |> Ecto.put_meta(state: :loaded)

      {:ok, status_uuid} = Ecto.UUID.cast(i.status)
      {:ok, type_uuid}   = Ecto.UUID.cast(i.type)

      %{i | status: status_uuid, type: type_uuid }
    end)
  end

  def create(attrs \\ %{}) do
    Repo.query("
    INSERT INTO invoice
    (data, company_data, line_data, log_data, contact_data, status, type)
    VALUES ($1, $2, $3, $4, $5, md5($6)::uuid, md5($7)::uuid)
    RETURNING id",
    [attrs.data, attrs.company_data, attrs.line_data, attrs.log_data, attrs.contact_data, attrs.status, attrs.type])
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
