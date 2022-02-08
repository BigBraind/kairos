defmodule Lifecycle.Money do
  @moduledoc """
  The Money context.
  """

  import Ecto.Query, warn: false
  alias Lifecycle.Repo

  alias Lifecycle.Money.Billing

  @doc """
  Returns the list of billings.

  ## Examples

      iex> list_billings()
      [%Billing{}, ...]

  """
  def list_billings do
    Repo.all(Billing)
  end

  @doc """
  Gets a single billing.

  Raises `Ecto.NoResultsError` if the Billing does not exist.

  ## Examples

      iex> get_billing!(123)
      %Billing{}

      iex> get_billing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_billing!(id), do: Repo.get!(Billing, id)

  @doc """
  Creates a billing.

  ## Examples

      iex> create_billing(%{field: value})
      {:ok, %Billing{}}

      iex> create_billing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_billing(attrs \\ %{}) do
    %Billing{}
    |> Billing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a billing.

  ## Examples

      iex> update_billing(billing, %{field: new_value})
      {:ok, %Billing{}}

      iex> update_billing(billing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_billing(%Billing{} = billing, attrs) do
    billing
    |> Billing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a billing.

  ## Examples

      iex> delete_billing(billing)
      {:ok, %Billing{}}

      iex> delete_billing(billing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_billing(%Billing{} = billing) do
    Repo.delete(billing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking billing changes.

  ## Examples

      iex> change_billing(billing)
      %Ecto.Changeset{data: %Billing{}}

  """
  def change_billing(%Billing{} = billing, attrs \\ %{}) do
    Billing.changeset(billing, attrs)
  end
end
