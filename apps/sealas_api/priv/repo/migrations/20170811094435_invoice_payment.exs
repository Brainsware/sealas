defmodule SealasApi.Repo.Migrations.InvoicePayment do
  use Ecto.Migration

  def change do
    create table(:invoice_payment) do
      add :invoice_id,  references(:invoice)

      add :data,         :text, null: true
      add :year,         :uuid, null: true
      add :month,        :uuid, null: true
      add :ext_id,       :uuid, null: true
    end

    create index(:invoice_payment, [:month])
    create index(:invoice_payment, [:year])
    create index(:invoice_payment, [:invoice_id])
  end
end
