defmodule Lifecycle.Massline do
  @moduledoc """
  The Massline User/Party context.
  """

  import Ecto.Query, warn: false
  alias Lifecycle.Repo

  alias Lifecycle.Users.User
  alias Lifecycle.Users.Party
  alias Lifecycle.Bridge.Membership

  @doc """
  Returns the list of parties

  ## Examples

      iex> list_parties()
      [%Party{}, ...]

  """
  def list_parties do
    Repo.all(from(p in Party, preload: [:user]))
  end

  @doc """
  Returns the list of members

  ## Examples

      iex> list_parties()
      [%Party{}, ...]

  """
  def list_members do
    Repo.all(from(p in Party, preload: [:user]))
  end

  @doc """
  Returns the list of members

  ## Examples

      iex> list_parties()
      [%Party{}, ...]

  """
  def add_member(attrs \\ %{}) do
    %Membership{}
        |> Membership.changeset(attrs)
        |> Repo.insert()
  end

  @doc """
  Returns the list of members

  ## Examples

      iex> list_parties()
      [%Party{}, ...]

  """
  def subtract_member(%Membership{} = member) do
    Repo.delete(member)
  end

  @doc """
  Gets a single party.

  Raises `Ecto.NoResultsError` if the Party does not exist.

  ## Examples

      iex> get_party!(123)
      %Party{}

      iex> get_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_party!(id), do: Repo.get!(Party, id) |> Repo.preload([:user])

  @doc """
  Creates a party.

  ## Examples

      iex> create_party(%{field: value})
      {:ok, %Party{}}

      iex> create_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_party(attrs \\ %{}) do
    case attrs do
      %{"founder_id" => user_id} ->
        {:ok, party} =
          %Party{}
          |> Party.changeset(attrs)
          |> Repo.insert()

        %Membership{}
        |> Membership.changeset(%{role: "lead", party_id: party.id, user_id: user_id})
        |> Repo.insert()

        {:ok, party}

      %{} ->
        %Party{}
        |> Party.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
  Updates a party.

  ## Examples

      iex> update_party(party, %{field: new_value})
      {:ok, %Party{}}

      iex> update_party(party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_party(%Party{} = party, attrs) do
    party
    |> Party.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a party.

  ## Examples

      iex> delete_party(party)
      {:ok, %Party{}}

      iex> delete_party(party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_party(%Party{} = party) do
    Repo.delete(party)
  end


    @doc """
  Returns an `%Ecto.Changeset{}` for tracking party changes.

  ## Examples

      iex> change_party(party)
      %Ecto.Changeset{data: %Party{}}

  """
  def change_party(%Party{} = party, attrs \\ %{}) do
    Party.changeset(party, attrs)
  end

end
