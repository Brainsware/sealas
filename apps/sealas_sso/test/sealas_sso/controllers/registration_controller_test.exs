defmodule SealasSso.RegistrationControllerTest do
  use SealasSso.ConnCase

  import Swoosh.TestAssertions

  alias SealasSso.Repo
  alias SealasSso.Accounts.User

  @create_attrs %{email: "some@email.com", password: "some password", active: true}

  @registration_attrs %{email: "some@email.com", locale: "en"}

  @verify_create_attrs %{email: "some@email.com", activation_code: "12344312asdfgZXCV"}
  @verification_attrs %{password: "hashed password yall", password_hint: "so secret, mhhhh", appkey: "very encrypted key to your application", salt: "salty boi"}

  describe "registration" do
    test "register as a new user", %{conn: conn} do
      conn = post conn, registration_path(conn, :create), user: @registration_attrs
      assert %{"activation_code" => activation_code} = json_response(conn, 201)

      assert_email_sent SealasSso.UserMail.verification(%{email: @registration_attrs.email, activation_code: activation_code})
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
      assert %{"activation_code" => activation_code} = json_response(conn, 201)
      assert String.length(activation_code) > 1

      conn = post conn, registration_path(conn, :create), user: @registration_attrs
      assert %{"error" => "retry_validation", "activation_code" => activation_code} = json_response(conn, 400)
    end
  end

  describe "verification" do
    def user_fixture() do
      {:ok, user} = User.create(@verify_create_attrs)

      user
    end

    test "confirm verification code", %{conn: conn} do
      user = user_fixture()

      conn = get conn, registration_path(conn, :show, @verify_create_attrs.activation_code)
      assert json_response(conn, 200)
    end

    test "don't confirm wrong verification code", %{conn: conn} do
      user = user_fixture()

      conn = get conn, registration_path(conn, :show, "wrong_code")
      assert json_response(conn, 400)
    end

    test "verify registration successful", %{conn: conn} do
      user = user_fixture()

      conn = post conn, registration_path(conn, :create), %{code: @verify_create_attrs.activation_code, user: @verification_attrs}
      assert json_response(conn, 201)
    end

    test "verification fails with wrong code", %{conn: conn} do
      user = user_fixture()

      conn = post conn, registration_path(conn, :create), %{code: "wrong_code", user: @verification_attrs}
      assert json_response(conn, 400) == %{"error" => "wrong_code"}
    end

    # TODO: Quickcheck parameter testing
  end
end
