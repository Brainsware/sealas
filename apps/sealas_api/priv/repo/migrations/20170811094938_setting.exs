defmodule SealasApi.Repo.Migrations.Setting do
  use Ecto.Migration

  def change do
    create table(:setting) do
      add :data,         :text, null: true
    end
  end
end
