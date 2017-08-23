defmodule SealasApi.Repo.Migrations.InvoicePaymentView do
  use Ecto.Migration

  def change do
    execute """
    CREATE view invoice_payment_view 
    AS
      SELECT invoice_payment.id             AS id,
             invoice_payment.invoice_id     AS invoice_id,
             invoice_payment.bankaccount_id AS bankaccount_id,
             invoice_payment.data           AS data,
             Hex(invoice_payment.year)      AS year,
             Hex(invoice_payment.month)     AS month,
             Hex(invoice_payment.ext_id)    AS ext_id
      FROM   invoice_payment;
    """
  end
end
