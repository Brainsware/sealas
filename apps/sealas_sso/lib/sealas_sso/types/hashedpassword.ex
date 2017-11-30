defmodule EctoHashedPassword do
  @behaviour Ecto.Type

  def type, do: :string

  def cast(password) when is_binary(password) do
    {:ok, Comeonin.Argon2.hashpwsalt(password)}
  end
  def cast(_), do: :error

  def load(password) when is_binary(password), do: {:ok, password}
  def load(_), do: :error

  def dump(password) when is_binary(password), do: {:ok, password}
  def dump(_), do: :error

  def check(password, hash) do
    Comeonin.Argon2.checkpw(password, hash)
  end
end
