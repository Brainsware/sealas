defmodule SealasWeb.PageControllerTest do
  use SealasWeb.ConnCase

  setup do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  describe "index" do
    test "GET /", %{conn: conn} do
      conn = get conn, "/"
      assert html_response(conn, 200) =~ " "
    end
  end
end
