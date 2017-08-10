defmodule SealasApi.AccountingTest do
  use SealasApi.DataCase

  alias SealasApi.Accounting

  describe "invoice" do
    alias SealasApi.Accounting.Invoice

    @valid_attrs %{company_data: "some company_data", contact_data: "some contact_data", data: "some data", line_data: "some line_data", log_data: "some log_data", status: "some status", type: "some type"}
    @update_attrs %{company_data: "some updated company_data", contact_data: "some updated contact_data", data: "some updated data", line_data: "some updated line_data", log_data: "some updated log_data", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{company_data: nil, contact_data: nil, data: nil, line_data: nil, log_data: nil, status: nil, type: nil}

    def invoice_fixture(attrs \\ %{}) do
      {:ok, invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounting.create_invoice()

      invoice
    end

    test "list_invoice/0 returns all invoice" do
      invoice = invoice_fixture()
      assert Accounting.list_invoice() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Accounting.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      assert {:ok, %Invoice{} = invoice} = Accounting.create_invoice(@valid_attrs)
      assert invoice.company_data == "some company_data"
      assert invoice.contact_data == "some contact_data"
      assert invoice.data == "some data"
      assert invoice.line_data == "some line_data"
      assert invoice.log_data == "some log_data"
      assert invoice.status == "some status"
      assert invoice.type == "some type"
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounting.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      assert {:ok, invoice} = Accounting.update_invoice(invoice, @update_attrs)
      assert %Invoice{} = invoice
      assert invoice.company_data == "some updated company_data"
      assert invoice.contact_data == "some updated contact_data"
      assert invoice.data == "some updated data"
      assert invoice.line_data == "some updated line_data"
      assert invoice.log_data == "some updated log_data"
      assert invoice.status == "some updated status"
      assert invoice.type == "some updated type"
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounting.update_invoice(invoice, @invalid_attrs)
      assert invoice == Accounting.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Accounting.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Accounting.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Accounting.change_invoice(invoice)
    end
  end
end
