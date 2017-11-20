defmodule SealasSso.AuthControllerTest do
  use SealasSso.ConnCase

  alias SealasSso.Accounts

  @create_attrs %{email: "some email", password: "some password"}

  #@update_attrs %{email: "some updated email"}
  #@invalid_attrs %{email: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
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

      assert {true, _token, _signature} = JOSE.JWT.verify(jwk, {%{alg: :jose_jws_alg_hmac}, auth_token})

      #{:ok, token_creatd_at} = DateTime.from_unix(token.fields["created_at"])
      #assert DateTime.diff(DateTime.utc_now(), token_creatd_at) == 0
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
