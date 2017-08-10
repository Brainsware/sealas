defmodule SealasApi.Repo.Migrations.CreateInvoice do
  use Ecto.Migration

  def change do
    create table(:invoice) do
      add :contact_id,  references(:contact)
      add :category_id, references(:invoice_category)

      add :data,         :text, null: true
      add :contact_data, :text, null: true
      add :line_data,    :text, null: true
      add :log_data,     :text, null: true
      add :company_data, :text, null: true
      add :type,         :binary, null: true, size: 5
      add :status,       :binary, null: true, size: 5
    end

  end
end
