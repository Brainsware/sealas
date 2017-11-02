defmodule SealasSso.Accounts.User do
  @moduledoc """
  This module holds our users schema.
  It's the point for all interactions via Ecto.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias SealasSso.Accounts.User

  @doc """
  We only identify users by email. Note that password, password_backup and
  are cryptographic hashes, not the original entry!
  """
  schema "users" do
    field :email,                :string
    field :password,             :string
    field :password_hint,        :string
    field :password_backup,      :string
    field :password_hint_backup, :string
    field :salt,                 :string
    field :name,                 :string
    field :locale,               :string, default: "de"
    field :active,               :boolean, default: false
    field :activation_code,      :string
    field :recovery_code,        :string

    timestamps()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> changeset(user)
      %Ecto.Changeset{source: %User{}}

  """
  @spec changeset(%User{}, map) :: %Ecto.Changeset{}
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
