defmodule SealasSso.Accounts.User do
  use BaseModel, repo: SealasSso.Repo
  import Ecto.Changeset

  alias SealasSso.Accounts.User
  alias SealasSso.Accounts.UserTfa

  schema "users" do
    has_many :user_tfa, UserTfa

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

  def create_random_password(length \\ 16) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end

  @doc false
  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :locale])
    |> validate_required([:email])
  end

  def test_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password])
  end
end
