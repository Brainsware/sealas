defmodule SealasSso.Accounts.UserTfa do
  use BaseModel, repo: SealasSso.Repo
  import Ecto.Changeset

  alias SealasSso.Accounts.User

  schema "user_tfa" do
    belongs_to :user, User

    field :type,     :string
    field :auth_key, :string

    timestamps()
  end

  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:type, :auth_key, :user_id])
    |> validate_required(:auth_key)
  end
end
