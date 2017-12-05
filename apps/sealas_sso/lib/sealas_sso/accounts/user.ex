defmodule SealasSso.Accounts.User do
  use BaseModel, repo: SealasSso.Repo
  import Ecto.Changeset

  alias SealasSso.Accounts.User
  alias SealasSso.Accounts.UserTfa

  @doc """
  We only identify users by email. Note that password and password_backup
  are cryptographic hashes, not the original entry!
  """
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

  @doc """
  Create a random string of characters
  For use as a password or activation/recovery code. Or anything else, really.
  """
  @spec create_random_password(integer) :: String.t
  def create_random_password(length \\ 16) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end

  @doc """
  Create changeset for registration
  Registration only requires email, locale and an activation code
  """
  @spec create_changeset(map) :: %Ecto.Changeset{}
  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:email, :locale, :activation_code])
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  @doc """
  Just for testing

  Only during testing do we ever need to create a user from a blob of hash attributes
  """
  @spec create_test_changeset(%User{}, map) :: %Ecto.Changeset{}
  def create_test_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_hint, :salt, :name, :locale, :active, :activation_code])
  end
end
