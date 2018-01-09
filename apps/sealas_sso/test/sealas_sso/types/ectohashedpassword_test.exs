defmodule SealasSso.EctoHashedPasswordTest do
  use SealasSso.DataCase

  @doc """
  Argon2 hash of string test_password
  """
  @argon2_hash "$argon2i$v=19$m=65536,t=6,p=1$79ljDB93b7A3W4LsbyoI2A$yiYBzrw1OaQiS86YESKTrwh8l9NnsUpbugddemKPv0w"

  describe "casting custom ecto hashed password" do
    test "type", do: assert EctoHashedPassword.type == :string

    test "cast and verify" do
      assert {:ok, hash} = EctoHashedPassword.cast("test_password")

      assert EctoHashedPassword.checkpw("test_password", hash)
      refute EctoHashedPassword.checkpw("wrong_password", hash)
    end

    test "verify argon2 hash", do: assert EctoHashedPassword.checkpw("test_password", @argon2_hash)
  end
end
