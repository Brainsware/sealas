defmodule SealasApi.Accounting.Invoice do
  @moduledoc """
  This module holds our invoice schema.
  It's the point for all interactions via Ecto.
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias SealasApi.Repo
  alias SealasApi.Accounting.Invoice
  alias SealasApi.Accounting.InvoiceCategory
  alias SealasApi.Accounting.InvoicePayment
  alias SealasApi.Accounting.Contact

  @doc """
  This schema is where we define encrypted data necessary our users' accounting:
  - invoices
  - quotes
  - expenses
  Note that `_data` fields are symmetrically encrypted, while EctoHashIndex
  fields are cryptographic hashes.
  """
  schema "invoice" do
    belongs_to :contact,          Contact
    belongs_to :invoice_category, InvoiceCategory
    has_many   :invoice_payment,  InvoicePayment

    field :company_data, :string
    field :contact_data, :string
    field :data,         :string
    field :line_data,    :string
    field :log_data,     :string
    field :status,       EctoHashIndex
    field :type,         EctoHashIndex
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> changeset(invoice)
      %Ecto.Changeset{source: %Invoice{}}

  """
  @spec changeset(%Invoice{}, map) :: %Ecto.Changeset{}
  def changeset(%Invoice{} = invoice, attrs) do
    invoice
    |> cast(attrs, [:data, :contact_data, :line_data, :log_data, :company_data, :status, :type])
  end

  @doc """
  Returns a list of all Invoices
  """
  @spec list(map) :: Scrivener.Page.t
  def list(params \\ %{}) do
    Repo.paginate(Invoice, params)
  end

  @doc """
  Gets a single invoice (by ID).

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get!(123)
      %Invoice{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get!(Integer) :: %Invoice{} | Ecto.NoResultsError
  def get!(id), do: Repo.get!(Invoice, id)

  @doc """
  Dispatch getter by type XOR status

  Returns an empty list if nothing matches, or a list of %Invoice{}s otherwise.

  ## Examples

      iex> get_by!("type", "lols")
      [%Invoice{}]

      iex> get_by!("status", "sob")
      []

  """
  @spec get_by!(String.t, String.t, map) :: Scrivener.Page.t
  def get_by!(type, value, params \\ %{}) do
    Repo.paginate(case type do
      "status" -> from i in Invoice, where: i.status == ^value
      "type"   -> from i in Invoice, where: i.type == ^value
    end, params)
  end

  @doc """
  creates an Invoice from the supplied map of attributes.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Invoice{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create(map) :: {:ok, %Invoice{}} | {:error, %Ecto.Changeset{}}
  def create(attrs \\ %{}) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  updates an Invoice with the supplied map of attributes.

  ## Examples

      iex> update(invoice, %{field: value})
      {:ok, %Invoice{}}

      iex> update(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update(%Invoice{}, map) :: {:ok, %Invoice{}} | {:error, %Ecto.Changeset{}}
  def update(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes an Invoice.

  ## Examples

      iex> delete(invoice)
      {:ok, %Invoice{}}

      iex> delete(invoice)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete(%Invoice{}) :: {:ok, %Invoice{}} | {:error, %Ecto.Changeset{}}
  def delete(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end
end
