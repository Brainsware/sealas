defmodule SealasApi.Repo.Migrations.InvoicePayment do
  use Ecto.Migration

  def change do
    create table(:invoice_payment) do
      add :invoice_id,  references(:invoice)

      add :data,         :text, null: true
      add :year,         :binary, null: true, size: 5
      add :month,        :binary, null: true, size: 5
      add :ext_id,       :binary, null: true, size: 32
    end

    create index(:invoice_payment, [:month])
    create index(:invoice_payment, [:year])
    create index(:invoice_payment, [:invoice_id])
  end
end
