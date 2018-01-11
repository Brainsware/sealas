defmodule SealasSso.Accounts.Account do
  use BaseModel, repo: SealasSso.Repo
  import Ecto.Changeset

  alias SealasSso.Accounts.User

  schema "account" do
    belongs_to :user, User

    field :appkey,        :string
    field :appkey_backup, :string
    field :slug,          :string
    field :active,        :boolean
    field :installed,     :boolean

    timestamps()
  end

  @doc """
  Changeset for create(). Only allows for type "yubikey" for now.
  """
  @spec create_changeset(map) :: %Ecto.Changeset{}
  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:appkey, :slug])
    |> validate_required(:appkey, :slug)
  end
end
