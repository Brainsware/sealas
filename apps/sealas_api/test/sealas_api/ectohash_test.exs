defmodule SealasApi.EctoHashIndexTest do
  use SealasApi.DataCase
  import Ecto.Query, warn: false

  describe "casting custom ecto hash type" do
    test "cast" do
      assert EctoHashIndex.cast("test_invoice") == {:ok, "c13bbe22-f8f6-55a0-47af-313e82edfbbd"}
    end

    test "cast uuid" do
      assert EctoHashIndex.cast("c13bbe22-f8f6-55a0-47af-313e82edfbbd") == {:ok, "c13bbe22-f8f6-55a0-47af-313e82edfbbd"}
    end

    test "dump" do
      {:ok, hash} = EctoHashIndex.cast("test_invoice")

      assert EctoHashIndex.dump(hash) == {:ok, <<193, 59, 190, 34, 248, 246, 85, 160, 71, 175, 49, 62, 130, 237, 251, 189>>}
    end

    test "load" do
      assert EctoHashIndex.load(<<193, 59, 190, 34, 248, 246, 85, 160, 71, 175, 49, 62, 130, 237, 251, 189>>) == EctoHashIndex.cast("test_invoice")
    end
  end
end
