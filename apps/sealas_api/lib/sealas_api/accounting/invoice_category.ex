defmodule SealasApi.Accounting.InvoiceCategory do
  use Ecto.Schema
  import Ecto.Changeset
  alias SealasApi.Accounting.InvoiceCategory


  schema "invoice_category" do
    field :data,         :string
  end

  @doc false
  def changeset(%InvoiceCategory{} = invoice_category, attrs) do
    invoice_category
    |> cast(attrs, [:data])
  end
end
