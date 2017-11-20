defmodule SealasSso.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SealasSso.Accounts.User

  schema "users" do
    field :email,                :string
    field :password,             EctoHashedPassword
    field :password_hint,        :string
    field :password_backup,      EctoHashedPassword
    field :password_hint_backup, :string
    field :salt,                 :string
    field :name,                 :string
    field :locale,               :string, default: "de"
    field :active,               :boolean, default: false
    field :activation_code,      :string
    field :recovery_code,        :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email])
  end
end
