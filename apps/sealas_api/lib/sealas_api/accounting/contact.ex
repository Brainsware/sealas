defmodule SealasApi.Accounting.Contact do
  use Ecto.Schema
  import Ecto.Changeset
  alias SealasApi.Accounting.Contact


  schema "contact" do
    field :data,         :string
    field :ext_id,       Ecto.UUID
  end

  @doc false
  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, [:data, :ext_id])
  end
end
