defmodule EctoHashedPassword do
  @moduledoc """
  Ecto type for hashed passwords.

  Automatically hashes all stored passwords.
  """

  @dialyzer {:nowarn_function, checkpw: 2}
  @behaviour Ecto.Type
  def type, do: :string

  @doc """
  Hash password with currenly used hashing algorithm
  """
  def cast(password) when is_binary(password), do: {:ok, Comeonin.Argon2.hashpwsalt(password)}
  def cast(_), do: :error

  def load(password) when is_binary(password), do: {:ok, password}
  def load(_), do: :error

  def dump(password) when is_binary(password), do: {:ok, password}
  def dump(_), do: :error

  @doc """
  Check password against hash with currently used hashing algorithm.
  """
  @spec checkpw(String.t, String.t) :: boolean
  def checkpw(password, hash), do: Comeonin.Argon2.checkpw(password, hash)
end
