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

  @spec create_changeset(map) :: %Ecto.Changeset{}
  def create_changeset(params) do
    %__MODULE__{}
    |> cast(params, [:type, :auth_key, :user_id])
    |> validate_required(:auth_key)
    |> validate_format(:type, ~r/yubikey/)
  end

  @spec validate_yubikey(String.t, boolean) :: {}
  def validate_yubikey(key, enable_test \\ true) do
    client_id   = Application.get_env(:sealas_sso, SealasSso.Yubikey)[:client_id]
    secret      = Application.get_env(:sealas_sso, SealasSso.Yubikey)[:secret]
    skip_server = Application.get_env(:sealas_sso, SealasSso.Yubikey)[:skip_server]

    cond do
      skip_server && enable_test ->
        {:auth, :ok}
      client_id && secret ->
        :yubico.simple_verify(key, client_id, secret, [])
      true ->
        {:error, :no_yubico_credentials}
    end
  end

  @spec extract_yubikey(String.t) :: String.t
  def extract_yubikey(key) do
    {key, _auth} = String.split_at(key, -32)

    key
  end
end
