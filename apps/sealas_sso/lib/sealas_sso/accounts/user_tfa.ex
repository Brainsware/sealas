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

  def validate_yubikey(key) do
    client_id = Application.get_env(:sealas_sso, SealasSso.Yubikey)[:client_id]
    secret    = Application.get_env(:sealas_sso, SealasSso.Yubikey)[:secret]
    
    cond do
      client_id && secret ->
        :yubico.simple_verify(key, client_id, secret, [])
      true ->
        {:error, :no_yubico_credentials}
    end
  end

  def extract_yubikey(key) do
    {key, _auth} = String.split_at(key, -32)

    key
  end
end
