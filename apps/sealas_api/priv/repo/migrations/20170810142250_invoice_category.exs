defmodule SealasApi.Repo.Migrations.CreateInvoiceCategory do
  use Ecto.Migration

  def change do
    create table(:invoice_category) do
      add :data,         :text, null: true
    end

  end
end
