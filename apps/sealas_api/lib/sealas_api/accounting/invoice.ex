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
    attrs = if Map.has_key?(attrs, "status") do
      Map.merge(attrs, %{"status" => :crypto.hash(:md5, attrs["status"]), "type" => :crypto.hash(:md5, attrs["type"])})
    else
      %{attrs | status: :crypto.hash(:md5, attrs.status), type: :crypto.hash(:md5, attrs.type) }
    end

    #attrs = if Map.has_key?(attrs, "type"), do: Map.merge(attrs, %{type: attrs["type"]}), else: attrs

    #attrs = %{attrs | status: :crypto.hash(:md5, attrs.status), type: :crypto.hash(:md5, attrs.type) }

    invoice
    |> cast(attrs, [:data, :contact_data, :line_data, :log_data, :company_data, :status, :type])
  end

  def list do
    Repo.all(Invoice)
  end

  def get!(id), do: Repo.get!(Invoice, id)

  def get_by!(type, value) do
    query = from i in Invoice

    {:ok, hash} = Ecto.UUID.cast(:crypto.hash(:md5, value))

    query = case type do
      "status" -> from i in query, where: i.status == ^hash
      "type"   -> from i in query, where: i.type == ^hash
    end

    Repo.all(query)
  end

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
