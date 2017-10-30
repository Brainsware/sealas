defmodule SealasApiWeb.InvoiceControllerTest do
  use SealasApi.ConnCase

  alias SealasApi.Accounting
  alias SealasApi.Accounting.Invoice

  @create_attrs %{company_data: "some company_data", contact_data: "some contact_data", data: "some data", line_data: "some line_data", log_data: "some log_data", status: "some status", type: "some type"}
  @update_attrs %{company_data: "some updated company_data", contact_data: "some updated contact_data", data: "some updated data", line_data: "some updated line_data", log_data: "some updated log_data", status: "some updated status", type: "some updated type"}
  @invalid_attrs %{company_data: nil, contact_data: nil, data: nil, line_data: nil, log_data: nil, status: nil, type: nil}

  def fixture(:invoice) do
    {:ok, invoice} = Accounting.create_invoice(@create_attrs)
    invoice
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all invoice", %{conn: conn} do
      conn = get conn, invoice_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
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
        "status" => "some status",
        "type" => "some type"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, invoice_path(conn, :create), invoice: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
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
        "status" => "some updated status",
        "type" => "some updated type"}
    end

    test "renders errors when data is invalid", %{conn: conn, invoice: invoice} do
      conn = put conn, invoice_path(conn, :update, invoice), invoice: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
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
