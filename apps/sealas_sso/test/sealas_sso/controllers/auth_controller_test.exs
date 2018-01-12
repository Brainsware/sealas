defmodule SealasSso.AuthControllerTest do
  use SealasSso.ConnCase

  alias SealasSso.Repo
  alias SealasSso.Accounts.User
  alias SealasSso.Accounts.UserTfa

  @minimum_request_time 190_000

  @create_attrs %{email: "some@email.com", password: "some password", active: true}
  @valid_login  %{email: "some@email.com", password: "some password"}
  @failed_login %{email: "some@email.com", password: "wrong password"}

  @create_tfa_attrs %{type: "yubikey", auth_key: "cccccccccccc"}
  @test_yubikey "cccccccccccccccccccccccccccccccfilnhluinrjhl"

  def fixture(:user) do
    {:ok, user} = %User{}
      |> User.create_test_changeset(@create_attrs)
      |> Repo.insert()
    user
  end

  def fixture(:user, :with_tfa) do
    user = fixture(:user)
    {:ok, _tfa}  = UserTfa.create(Map.put(@create_tfa_attrs, :user, user))
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sso timing" do
    test "minimum request time", %{conn: conn} do
      time = Time.utc_now()

      get conn, auth_path(conn, :index), @failed_login

      diff = Time.diff(Time.utc_now(), time, :microsecond)
      assert diff >= @minimum_request_time
    end
  end

  describe "login" do
    setup [:create_user]

    test "successful authentication as a user", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @valid_login
      assert %{"auth" => auth_token} = json_response(conn, 201)

      conn = conn
      |> recycle()
      |> put_req_header("authorization", "bearer: " <> auth_token)
      |> get(user_path(conn, :index))

      assert json_response(conn, 200)
    end

    test "fail to authenticate with wrong password", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @failed_login
      assert json_response(conn, 401) == %{"error" => "auth fail"}
    end

    test "get 401 for protected route", %{conn: conn} do
      conn = conn |> get(user_path(conn, :index))

      assert json_response(conn, 401) == %{"error" => "auth_fail"}
    end

    test "deny request with timedout token", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @valid_login
      assert %{"auth" => auth_token} = json_response(conn, 201)

      {:ok, token} = AuthToken.decrypt_token(auth_token)
      {:ok, auth_token} = AuthToken.generate_token %{token | "ct" => DateTime.utc_now() |> DateTime.to_unix() |> Kernel.-(864000)}

      conn = conn
      |> recycle()
      |> put_req_header("authorization", "bearer: " <> auth_token)
      |> get(user_path(conn, :index))

      assert json_response(conn, 401) == %{"error" => "timeout"}
    end

    test "refresh stale token", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @valid_login
      assert %{"auth" => auth_token} = json_response(conn, 201)

      # Fake stale token
      {:ok, token} = AuthToken.decrypt_token(auth_token)
      {:ok, auth_token} = AuthToken.generate_token %{token | "rt" => DateTime.utc_now() |> DateTime.to_unix() |> Kernel.-(3600)}

      conn = conn
      |> recycle()
      |> put_req_header("authorization", "bearer: " <> auth_token)
      |> get(user_path(conn, :index))

      assert json_response(conn, 401) == %{"error" => "needs_refresh"}

      # Refresh token
      conn = get conn, auth_path(conn, :index), %{token: auth_token}
      assert %{"auth" => auth_token} = json_response(conn, 201)

      # And retry request
      conn = conn
      |> recycle()
      |> put_req_header("authorization", "bearer: " <> auth_token)
      |> get(user_path(conn, :index))

      assert json_response(conn, 200)
    end
  end

  describe "login with TFA" do
    setup [:create_user_with_tfa]

    test "successful authentication with TFA", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @valid_login
      assert %{"tfa" => true, "code" => tfa_code} = json_response(conn, 201)

      conn = get conn, auth_path(conn, :index), %{code: tfa_code, auth_key: @test_yubikey}
      assert %{"auth" => _auth_token} = json_response(conn, 201)
    end

    test "fail to authenticate with wrong password", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @failed_login
      assert json_response(conn, 401) == %{"error" => "auth fail"}
    end

    test "failed authentication with TFA", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @valid_login
      assert %{"tfa" => true, "code" => tfa_code} = json_response(conn, 201)

      conn = get conn, auth_path(conn, :index), %{code: "wrong code!", auth_key: "wrong key!"}
      assert json_response(conn, 401) == %{"error" => "auth fail"}

      conn = get conn, auth_path(conn, :index), %{code: tfa_code, auth_key: "wrong key!"}
      assert json_response(conn, 401) == %{"error" => "auth fail"}
    end
  end

  describe "unvalidated user" do
    test "fail to authenticate with unvalidated user", %{conn: conn} do
      {:ok, user} = %User{}
      |> User.create_test_changeset(%{email: "email", activation_code: "code", active: false})
      |> Repo.insert()

      conn = get conn, auth_path(conn, :index), %{email: "email", password: "password"}
      assert %{"error" => "retry_validation", "activation_code" => _code} = json_response(conn, 400)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp create_user_with_tfa(_) do
    user = fixture(:user, :with_tfa)
    {:ok, user: user}
  end
end
