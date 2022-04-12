defmodule Lifecycle.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Lifecycle.Repo

  alias Lifecycle.Users.Realm

  @doc """
  Returns the list of realms.

  ## Examples

      iex> list_realms()
      [%Realm{}, ...]

  """
  def list_realms do
    Repo.all(Realm)
  end

  @doc """
  Gets a single realm.

  Raises `Ecto.NoResultsError` if the Realm does not exist.

  ## Examples

      iex> get_realm!(123)
      %Realm{}

      iex> get_realm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_realm!(id), do: Repo.get!(Realm, id)
  def get_realm_by_name!(name), do: Repo.get_by!(Realm, name: name)

  @doc """
  Creates a realm.

  ## Examples

      iex> create_realm(%{field: value})
      {:ok, %Realm{}}

      iex> create_realm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_realm(attrs \\ %{}) do
    %Realm{}
    |> Realm.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a realm.

  ## Examples

      iex> update_realm(realm, %{field: new_value})
      {:ok, %Realm{}}

      iex> update_realm(realm, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_realm(%Realm{} = realm, attrs) do
    realm
    |> Realm.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a realm.

  ## Examples

      iex> delete_realm(realm)
      {:ok, %Realm{}}

      iex> delete_realm(realm)
      {:error, %Ecto.Changeset{}}

  """
  def delete_realm(%Realm{} = realm) do
    Repo.delete(realm)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking realm changes.

  ## Examples

      iex> change_realm(realm)
      %Ecto.Changeset{data: %Realm{}}

  """
  def change_realm(%Realm{} = realm, attrs \\ %{}) do
    Realm.changeset(realm, attrs)
  end
end
