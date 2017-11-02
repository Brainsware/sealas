defmodule SealasApi.Accounting.Contact do
  @moduledoc """
  This holds our customers' contacts (e.g: their customers, etc).
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias SealasApi.Accounting.Contact


  @doc """
  The contact schema is (encrypted) contact data, and a cryptographic hash that
  points to it
  """
  schema "contact" do
    field :data,         :string
    field :ext_id,       EctoHashIndex
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking contact changes.

  ## Examples

      iex> changeset(contact)
      %Ecto.Changeset{source: %Contact{}}

  """
  @spec changeset(%Contact{}, map) :: %Ecto.Changeset{}
  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, [:data, :ext_id])
  end
end
