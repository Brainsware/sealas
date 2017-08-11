defmodule SealasApi.Repo.Migrations.ContactView do
  use Ecto.Migration

  def change do
    execute """
    CREATE VIEW contact_view AS
    SELECT contact.id AS id, hex(contact.ext_id) AS ext_id, contact.data AS data
    FROM contact ;
    """
  end
end
