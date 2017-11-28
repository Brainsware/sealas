defmodule SealasSso.AuthControllerTest do
  use SealasSso.ConnCase

  alias SealasSso.Repo
  alias SealasSso.Accounts.User
  alias SealasSso.Accounts.UserTfa

  @minimum_request_time 190_000

  @create_attrs %{email: "some email", password: "some password"}
  @failed_login %{email: "some email", password: "wrong password"}

  @create_tfa_attrs %{type: "yubikey", auth_key: "cccccccccccc"}
  @test_yubikey "cccccccccccccccccccccccccccccccfilnhluinrjhl"

  @registration_attrs %{email: "some@email.com", locale: "en"}

  def fixture(:user) do
    {:ok, user} = %User{}
      |> User.test_changeset(@create_attrs)
      |> Repo.insert()
    user
  end

  def fixture(:user, :with_tfa) do
    user = fixture(:user)
    {:ok, tfa}  = UserTfa.create(Map.put(@create_tfa_attrs, :user, user))
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
      conn = get conn, auth_path(conn, :index), @create_attrs
      assert %{"auth" => auth_token} = json_response(conn, 201)

      key = Application.get_env(:sealas_sso, SealasSso.Endpoint)[:token_key]

      jwk = %{"kty" => "oct", "k" => :base64url.encode(key)}

      assert {true, token, _signature} = JOSE.JWT.verify(jwk, {%{alg: :jose_jws_alg_hmac}, auth_token})

      {:ok, token_creatd_at} = DateTime.from_unix(token.fields["created_at"])
      assert DateTime.diff(DateTime.utc_now(), token_creatd_at) >= 0

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

      assert json_response(conn, 401) == %{"error" => "auth fail"}
    end
  end

  describe "login with TFA" do
    setup [:create_user_with_tfa]

    test "successful authentication with TFA", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @create_attrs
      assert %{"tfa" => true, "code" => tfa_code} = json_response(conn, 201)

      conn = get conn, auth_path(conn, :index), %{code: tfa_code, auth_key: @test_yubikey}
      assert %{"auth" => auth_token} = json_response(conn, 201)
    end

    test "fail to authenticate with wrong password", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @failed_login
      assert json_response(conn, 401) == %{"error" => "auth fail"}
    end

    test "failed authentication with TFA", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @create_attrs
      assert %{"tfa" => true, "code" => tfa_code} = json_response(conn, 201)

      conn = get conn, auth_path(conn, :index), %{code: "wrong code!", auth_key: "wrong key!"}
      assert json_response(conn, 401) == %{"error" => "auth fail"}

      conn = get conn, auth_path(conn, :index), %{code: tfa_code, auth_key: "wrong key!"}
      assert json_response(conn, 401) == %{"error" => "auth fail"}
    end
  end

  describe "registration" do
    test "register as a new user", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @registration_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]
    end

    test "register with an existing email", %{conn: conn} do
    end

    test "register with an existing unvalidated email", %{conn: conn} do
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
