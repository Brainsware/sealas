defmodule EctoHashIndex do
  @behaviour Ecto.Type
  def type, do: Ecto.UUID

  def cast(string) when is_binary(string) do
    case Regex.run(~r/\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/, string) do
      nil -> Ecto.UUID.cast :crypto.hash(:md5, string)

      [_] -> {:ok, string}
    end
  end
  def cast(uuid), do: Ecto.UUID.cast uuid

  defdelegate load(data), to: Ecto.UUID
  defdelegate dump(data), to: Ecto.UUID
end
