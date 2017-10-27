defmodule SealasApi.Repo.Migrations.CreateInvoice do
  use Ecto.Migration

  def change do
    create table(:invoice) do
      add :contact_id,          references(:contact), null: true
      add :invoice_category_id, references(:invoice_category), null: true

      add :data,         :text, null: true
      add :contact_data, :text, null: true
      add :line_data,    :text, null: true
      add :log_data,     :text, null: true
      add :company_data, :text, null: true
      add :type,         :uuid, null: true
      add :status,       :uuid, null: true
    end

    create index(:invoice, [:contact_id])
    create index(:invoice, [:type, :status])
    create index(:invoice, [:invoice_category_id])
  end
end
