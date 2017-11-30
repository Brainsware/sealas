defmodule SealasSso.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    # psql enum type:
    # execute("CREATE TYPE enum_name as ENUM ('test', 'bar')")
    # add :col, :enum_name

    create table(:users) do
      add :email,                :string
      add :password,             :string, null: true
      add :password_hint,        :string, null: true
      add :password_backup,      :string, null: true
      add :password_hint_backup, :string, null: true
      add :salt,                 :char,   size: 16, null: true
      add :name,                 :string, null: true
      add :locale,               :string, size: 5, default: "de"
      add :active,               :bool,   default: false
      add :activation_code,      :char,   size: 32, null: true
      add :recovery_code,        :char,   size: 32, null: true

      timestamps()
    end

    create unique_index(:users, [:email])

  end
end
