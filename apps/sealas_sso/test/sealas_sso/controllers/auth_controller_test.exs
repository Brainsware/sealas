defmodule SealasSso.AuthControllerTest do
  use SealasSso.ConnCase

  alias SealasSso.Repo
  alias SealasSso.Accounts.User

  @minimum_request_time 200_000

  @create_attrs %{email: "some email", password: "some password"}
  @failed_login %{email: "some email", password: "wrong password"}

  @registration_attrs %{email: "some@email.com", locale: "en"}

  def fixture(:user) do
    {:ok, user} = %User{}
      |> User.test_changeset(@create_attrs)
      |> Repo.insert()
    user
  end

  def fixture(:user, true) do
    {:ok, user} = fixture(:user)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_user]

    test "authenticate as a user", %{conn: conn} do
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

    test "minimum request time", %{conn: conn} do
      time = Time.utc_now()

      get conn, auth_path(conn, :index), @failed_login

      diff = Time.diff(Time.utc_now(), time, :microsecond)
      assert diff >= @minimum_request_time
    end

    test "fail to authenticate", %{conn: conn} do
      conn = get conn, auth_path(conn, :index), @failed_login
      assert json_response(conn, 401) == %{"error" => "auth fail"}
    end

    test "get 401 for protected route", %{conn: conn} do
      conn = conn |> get(user_path(conn, :index))

      assert json_response(conn, 401) == %{"error" => "auth fail"}
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
