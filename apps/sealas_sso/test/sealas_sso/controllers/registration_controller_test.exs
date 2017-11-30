defmodule SealasSso.RegistrationControllerTest do
  use SealasSso.ConnCase

  alias SealasSso.Repo
  alias SealasSso.Accounts.User
  alias SealasSso.Accounts.UserTfa

  @minimum_request_time 190_000

  @create_attrs %{email: "some@email.com", password: "some password", active: true}

  @registration_attrs %{email: "some@email.com", locale: "en"}

  describe "registration" do
    test "register as a new user", %{conn: conn} do
      conn = post conn, registration_path(conn, :create), user: @registration_attrs
      assert %{"activation_code" => _activation_code} = json_response(conn, 201)
    end

    test "register with an existing email", %{conn: conn} do
      {:ok, user} = %User{}
        |> User.create_test_changeset(@create_attrs)
        |> Repo.insert()

      conn = post conn, registration_path(conn, :create), user: @registration_attrs
      assert %{"error" => "already_registered"} = json_response(conn, 400)
    end

    test "register with an existing unvalidated email", %{conn: conn} do
      conn = post conn, registration_path(conn, :create), user: @registration_attrs
      assert %{"activation_code" => _activation_code} = json_response(conn, 201)

      conn = post conn, registration_path(conn, :create), user: @registration_attrs
      assert %{"error" => "retry_validation", "activation_code" => _activation_code} = json_response(conn, 400)
    end
  end
end
