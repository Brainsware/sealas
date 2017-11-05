defmodule SealasApi.InvoiceControllerTest do
  use SealasApi.ConnCase

  alias SealasApi.Accounting.Invoice

  @create_attrs %{company_data: "some company_data", contact_data: "some contact_data", data: "some data", line_data: "some line_data", log_data: "some log_data", status: "test_status", type: "test_invoice"}
  @update_attrs %{company_data: "some updated company_data", contact_data: "some updated contact_data", data: "some updated data", line_data: "some updated line_data", log_data: "some updated log_data", status: "updated_test_status", type: "updated_test_invoice"}

  @pager_params %{page: 1, page_size: 50}

  def fixture(:invoice) do
    {:ok, invoice} = Invoice.create(@create_attrs)
    invoice
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_invoice]

    test "lists all invoice", %{conn: conn, invoice: invoice} do
      conn = get conn, invoice_path(conn, :index), @pager_params
      assert json_response(conn, 200)["data"] == %{"page_number" => 1, "total_pages" => 1, "invoices" => [%{
        "id" => invoice.id,
        "company_data" => "some company_data",
        "contact_data" => "some contact_data",
        "data" => "some data",
        "line_data" => "some line_data",
        "log_data" => "some log_data",
        "status" => "15ee3ed0-0c85-bd21-b342-a90bbb7109d0",
        "type" => "c13bbe22-f8f6-55a0-47af-313e82edfbbd"}]}
    end
  end

  describe "create invoice" do
    test "renders invoice when data is valid", %{conn: conn} do
      conn = post conn, invoice_path(conn, :create), invoice: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, invoice_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "company_data" => "some company_data",
        "contact_data" => "some contact_data",
        "data" => "some data",
        "line_data" => "some line_data",
        "log_data" => "some log_data",
        "status" => "15ee3ed0-0c85-bd21-b342-a90bbb7109d0",
        "type" => "c13bbe22-f8f6-55a0-47af-313e82edfbbd"}
    end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post conn, invoice_path(conn, :create), invoice: @invalid_attrs
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "update invoice" do
    setup [:create_invoice]

    test "renders invoice when data is valid", %{conn: conn, invoice: %Invoice{id: id} = invoice} do
      conn = put conn, invoice_path(conn, :update, invoice), invoice: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, invoice_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "company_data" => "some updated company_data",
        "contact_data" => "some updated contact_data",
        "data" => "some updated data",
        "line_data" => "some updated line_data",
        "log_data" => "some updated log_data",
        "status" => "385de8df-ec5e-729e-0708-8756309ea886",
        "type" => "a5161f97-e5c2-8af9-0096-93337beb0261"}
    end

    # test "renders errors when data is invalid", %{conn: conn, invoice: invoice} do
    #   conn = put conn, invoice_path(conn, :update, invoice), invoice: @invalid_attrs
    #   assert json_response(conn, 422)["errors"] != %{}
    # end
  end

  describe "delete invoice" do
    setup [:create_invoice]

    test "deletes chosen invoice", %{conn: conn, invoice: invoice} do
      conn = delete conn, invoice_path(conn, :delete, invoice)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, invoice_path(conn, :show, invoice)
      end
    end
  end

  defp create_invoice(_) do
    invoice = fixture(:invoice)
    {:ok, invoice: invoice}
  end
end
