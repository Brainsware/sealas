defmodule SealasApi.EctoHashIndexTest do
  use SealasApi.DataCase
  import Ecto.Query, warn: false

  @test_invoice_uuid "c13bbe22-f8f6-55a0-47af-313e82edfbbd"
  @test_invoice_uuid_binary <<193, 59, 190, 34, 248, 246, 85, 160, 71, 175, 49, 62, 130, 237, 251, 189>>

  describe "casting custom ecto hash type" do
    test "cast" do
      assert EctoHashIndex.cast("test_invoice") == {:ok, @test_invoice_uuid}
    end

    test "cast uuid" do
      assert EctoHashIndex.cast(@test_invoice_uuid) == {:ok, @test_invoice_uuid}
    end

    test "dump" do
      {:ok, hash} = EctoHashIndex.cast("test_invoice")

      assert EctoHashIndex.dump(hash) == {:ok, @test_invoice_uuid_binary}
    end

    test "load" do
      assert EctoHashIndex.load(@test_invoice_uuid_binary) == EctoHashIndex.cast("test_invoice")
    end
  end
end
