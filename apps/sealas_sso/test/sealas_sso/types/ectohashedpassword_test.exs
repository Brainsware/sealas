defmodule SealasSso.EctoHashedPasswordTest do
  use SealasSso.DataCase

  describe "casting custom ecto hashed password" do
    test "cast" do
      assert {:ok, hash} = EctoHashedPassword.cast("test_password")

      assert EctoHashedPassword.check("test_password", hash)
    end
  end
end
