defmodule SealasSso.Repo.Migrations.AddAccount do
  use Ecto.Migration

  def change do
    create table(:account) do
      add :user_id,       references(:users)

      add :appkey,        :text
      add :appkey_backup, :text
      add :slug,          :varchar, size: 32
      add :active,        :boolean, default: false
      add :installed,     :boolean, default: false

      # store all company contact information
      add :company_info   :text

      timestamps()
    end
  end
end
