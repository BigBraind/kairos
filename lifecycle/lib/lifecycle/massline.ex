defmodule Lifecycle.Massline do
  @moduledoc """
  The Massline User/Party context.
  """

  import Ecto.Query, warn: false

  alias Lifecycle.Bridge.Membership
  alias Lifecycle.Repo
  alias Lifecycle.Users.Party
  alias Lifecycle.Users.User


  @doc """
  Returns the list of all parties

  Input: None

  ## Examples

    iex> list_parties()
    [%Party{}, ...]

  """
  def list_parties do
    Repo.all(from(p in Party, preload: [:user]))
  end

  @doc """
  Returns the list of members of a particular party

  Input:
    party_id: :binary_id

  ## Examples

  iex> list_members(id)
  [%User{}, ...]

  """
  def list_members(id) do
    query =
      Membership
      |> where([e], e.party_id == ^id)
      |> order_by([e], desc: e.inserted_at)
      |> preload(:user)

    Repo.all(query, limit: 8)
  end

  @doc """
  Returns the list of membership associated with the input user

  Input:
    user_id: :binary_id

  ## Examples

  iex> list_my_parties(id)
  [%Membership{}, ...]

  """
  def list_my_parties(id) do
    # includes role information
    query =
      Membership
      |> where([e], e.user_id == ^id)
      |> order_by([e], desc: e.inserted_at)
      |> preload(:party)

    Repo.all(query, limit: 8)
  end

  @doc """
  Adding user to a party

  Input: %{"role" => "pleb",
          "party_id" => :binary_id,
          "user_id" => :}

  ## Examples

  iex> add_member(%{"role" => "pleb", "party_id" => "54635226-84df-4364-95f9-c5d3a3713baf", "user_id" => "39116133-3ded-455b-b972-198c54552cdf"})
  {:ok, %Membership{}}

  """
  def add_member(attrs \\ %{}) do
    case attrs do
      %{"user_name" => user_name} ->
        case get_user_by_name(user_name) do
          %User{:id => user_id} ->
            attrs = Map.put(attrs, "user_id", user_id)

            %Membership{}
            |> Membership.changeset(attrs)
            |> Repo.insert()

          {:error, reason} ->
            {:error, reason}
        end

      %{"user_id" => _user_id} ->
        %Membership{}
        |> Membership.changeset(attrs)
        |> Repo.insert()
    end
  end

  @doc """
    Return the membership between the a party and a user

    Input: %{"party_id" => :binary_id,
            "user_id" => :binary_idz}

    ## Examples

    iex> get_member!(%{"party_id" => "54635226-84df-4364-95f9-c5d3a3713baf", "user_id" => "39116133-3ded-455b-b972-198c54552cdf"})
    %Membership{}

  """
  def get_member!(attrs),
    do: Repo.get_by!(Membership, party_id: attrs["party_id"], user_id: attrs["user_id"])

  @doc """
  Remove user from a party

  Input: %{"party_id" => :binary_id,
          "user_name" => :string}
          OR
  Input: %{"party_id" => :binary_id,
          "user_id" => :binary_id}

  ## Examples

  iex> subtract_member(%{"party_id" => "54635226-84df-4364-95f9-c5d3a3713baf", "user_name" => "sky"})
  {:ok, "member removed"}

  """
  def subtract_member(attrs \\ %{}) do
    case attrs do
      %{"user_name" => user_name, "party_id" => party_id} ->
        case get_user_by_name(user_name) do
          %User{:id => user_id} ->
            from(m in Membership, where: m.party_id == ^party_id and m.user_id == ^user_id)
            |> Repo.delete_all()

            {:ok, "member removed"}

          {:error, reason} ->
            {:error, reason}
        end

      %{"user_id" => user_id, "party_id" => party_id} ->
        from(m in Membership, where: m.party_id == ^party_id and m.user_id == ^user_id)
        |> Repo.delete_all()

        {:ok, "member removed"}
    end
  end

  @doc """
  Gets a single party.
  Raises `Ecto.NoResultsError` if the Party does not exist.

  Input:
    party_id: binary_id

  ## Examples

  iex> get_party!("7e66e29e-b302-4c66-915f-167dcf9c76e5")
  %Party{}

  iex> get_party!("456")
  ** (Ecto.NoResultsError)

  """
  def get_party!(id), do: Repo.get!(Party, id) |> Repo.preload([:user])

  @doc """
  Gets party's id by passing in party's name
  Raises `Ecto.NoResultsError` if the Party does not exist.

  Input:
    name: String

  ## Examples

  iex> get_party_by_name!("first party")
  %Party{}

  iex> get_party_by_name!("456")
  ** (Ecto.NoResultsError)
  """
  def get_party_by_name!(name), do: Repo.get_by!(Party, name: name) |> Repo.preload([:user])

  @doc """
  Gets user's id by passing in user's name
  """
  def get_user_by_name(name) do
    Repo.get_by!(User, name: name) |> Repo.preload([:parties])
  rescue
    Ecto.NoResultsError ->
      {:error, "user not found, make sure you enter the correct user name"}
  end

  @doc """
  Creates a party.

  Input:
    %{"founder_id" => :binary_id,
      "name" => :string,
      "banner" => :string}

  ## Examples

  iex> create_party(%{field: value})
  {:ok, %Party{}}

  iex> create_party(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_party(attrs \\ %{}) do
    case attrs do
      %{"founder_id" => user_id} ->
        party =
          %Party{}
          |> Party.changeset(attrs)
          |> Repo.insert()

        case party do
          {:ok, party} ->
            membership =
              %Membership{}
              |> Membership.changeset(%{role: "lead", party_id: party.id, user_id: user_id})
              |> Repo.insert()

            case membership do
              {:ok, _} -> {:ok, party}
              {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
            end

          {:error, %Ecto.Changeset{} = changeset} ->
            {:error, changeset}
        end

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
