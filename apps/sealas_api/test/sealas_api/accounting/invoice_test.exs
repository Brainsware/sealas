defmodule SealasApi.InvoiceTest do
  use SealasApi.DataCase

  alias SealasApi.Accounting.Invoice

  describe "invoice schema" do

    @valid_attrs %{company_data: "some company_data", contact_data: "some contact_data", data: "some data", line_data: "some line_data", log_data: "some log_data", status: "test_status", type: "test_invoice"}
    @update_attrs %{company_data: "some updated company_data", contact_data: "some updated contact_data", data: "some updated data", line_data: "some updated line_data", log_data: "some updated log_data", status: "some updated status", type: "some updated type"}

    ## type   'test_invoice': 'c13bbe22-f8f6-55a0-47af-313e82edfbbd'
    ## status 'test_status':  '15ee3ed0-0c85-bd21-b342-a90bbb7109d0'

    def invoice_fixture(attrs \\ %{}) do
      {:ok, invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Invoice.create()

      Invoice.get!(List.first(List.first(invoice.rows)))
    end

    test "list/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Invoice.list() == [invoice]
    end

    test "get!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Invoice.get!(invoice.id) == invoice
    end

    test "get_by!/2 returns all invoices with given status or type" do
      invoice = invoice_fixture()
      assert Invoice.get_by!("status", "test_status") == [invoice]
      assert Invoice.get_by!("type", "test_invoice") == [invoice]
    end

    test "update/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      assert {:ok, invoice} = Invoice.update(invoice, @update_attrs)
      assert %Invoice{} = invoice
      assert invoice.company_data == "some updated company_data"
      assert invoice.contact_data == "some updated contact_data"
      assert invoice.data == "some updated data"
      assert invoice.line_data == "some updated line_data"
      assert invoice.log_data == "some updated log_data"
    end

    test "delete/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Invoice.delete(invoice)
      assert_raise Ecto.NoResultsError, fn -> Invoice.get!(invoice.id) end
    end
  end
end
