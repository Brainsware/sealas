defmodule SealasSso.Repo.Migrations.AddUserTfa do
  use Ecto.Migration

  def change do
    create table(:user_tfa) do
      add :user_id,  references(:users)

      add :type,     :varchar, size: 16, default: "yubikey"
      add :auth_key, :text

      timestamps()
    end
  end
end
