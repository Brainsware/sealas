defmodule SealasApi.Accounting.Invoice do
  use Ecto.Schema
  import Ecto.Changeset
  alias SealasApi.Accounting.Invoice


  schema "invoice" do
    #field :contact_id,  references(:contact)
    #field :category_id, references(:category)

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
end
