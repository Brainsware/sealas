defmodule SealasApi.Accounting.InvoicePayment do
  use Ecto.Schema
  import Ecto.Changeset
  alias SealasApi.Accounting.Invoice
  alias SealasApi.Accounting.InvoicePayment


  schema "invoice_payment" do
    belongs_to :invoice, Invoice

    field :data,         :string
    field :year,         EctoHash
    field :month,        EctoHash
    field :ext_id,       EctoHash
  end

  @doc false
  def changeset(%InvoicePayment{} = invoice_category, attrs) do
    invoice_category
    |> cast(attrs, [:data])
  end
end
