defmodule SealasSso.UserTfaTest do
  use SealasSso.DataCase

  alias SealasSso.Repo

  describe "user tfa" do
    alias SealasSso.Accounts.User
    alias SealasSso.Accounts.UserTfa

    @create_user_attrs %{email: "some email", password: "some password"}

    @valid_attrs %{type: "yubikey", auth_key: "cccccccccccccccccccccccccccccccfilnhluinrjhl"}
    @invalid_attrs %{type: "yubikey", auth_key: nil}

    def user_fixture() do
      {:ok, user} = %User{}
        |> User.test_changeset(@create_user_attrs)
        |> Repo.insert()

      user
    end

    def tfa_fixture(user) do
      {:ok, tfa} = UserTfa.create(Map.put(@valid_attrs, :user, user))

      tfa
    end

    test "user_tfa/0 returns all tfa keys" do
      user = user_fixture()
      tfa  = tfa_fixture(user)

      user_tfas = Repo.preload(user, :user_tfa)

      assert user_tfas.user_tfa() == [tfa]
    end

    test "create tfa fails with invalid attrs" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} = UserTfa.create(Map.put(@invalid_attrs, :user, user))
    end

    test "delete tfa" do
      user = user_fixture()
      tfa  = tfa_fixture(user)

      assert UserTfa.delete(tfa) == :ok
    end
  end
end
