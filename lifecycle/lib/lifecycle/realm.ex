defmodule Lifecycle.Realm do
  @moduledoc """
  The Realm context.
  """

  import Ecto.Query, warn: false
  alias Lifecycle.Repo
  alias Lifecycle.Timeline
  alias Lifecycle.Realm.Journey


  @doc """
  Returns the list of journeys.

  ## Examples

      iex> list_journeys()
      [%Journey{}, ...]

  """
  def list_journeys do
    Repo.all(Journey)
  end

  @doc """
  Gets a single journey.

  Raises `Ecto.NoResultsError` if the Journey does not exist.

  ## Examples

      iex> get_journey!(123)
      %Journey{}

      iex> get_journey!(456)
      ** (Ecto.NoResultsError)

  """
  def get_journey!(id), do: Repo.get!(Journey, id)

  def get_journey_by_realm_attrs!(realm_name, pointer) do
    query = Journey
        |> where([j], j.realm_name == ^realm_name)
        |> where([j], j.pointer == ^pointer)
        |> order_by([e], desc: e.inserted_at)
        |> preload(:realm)

      Repo.one!(query)
  end

  @doc """
  Creates a journey.

  ## Examples

      iex> create_journey(%{field: value})
      {:ok, %Journey{}}

      iex> create_journey(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_journey(attrs \\ %{}) do
    %Journey{}
    |> Journey.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a journey.

  ## Examples

      iex> update_journey(journey, %{field: new_value})
      {:ok, %Journey{}}

      iex> update_journey(journey, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_journey(%Journey{} = journey, attrs) do
    journey
    |> Journey.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a journey.

  ## Examples

      iex> delete_journey(journey)
      {:ok, %Journey{}}

      iex> delete_journey(journey)
      {:error, %Ecto.Changeset{}}

  """
  def delete_journey(%Journey{} = journey) do
    Repo.delete(journey)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking journey changes.

  ## Examples

      iex> change_journey(journey)
      %Ecto.Changeset{data: %Journey{}}

  """
  def change_journey(%Journey{} = journey, attrs \\ %{}) do
    Journey.changeset(journey, attrs)
  end

  # def start_journey(attrs \\ %{}) do
  #   #realm is already created (append onto current realm + increment pointer by 1)

  #   {:ok , journey}= Journey.changeset(attrs) |> Repo.insert()
  #   journey

  #   # assoc_realm
  #   # create_transition()

  # end

  def start_journey(realm_attrs \\ %{}, journey_attrs \\ %{}) do
    # create_journey()
    {:ok, realm} =
      Lifecycle.Users.create_realm(realm_attrs)
    {:ok , journey}=
      Journey.changeset(journey_attrs
      |> Map.put(:realm_name, realm.name))
      |> Repo.insert()

      journey |> Repo.preload(:realm)
  end

  def continue_journey(transition_attrs \\ %{}, phase_attrs \\ %{}) do
    {:ok, p} = Lifecycle.Timeline.create_phase(phase_attrs)
    Lifecycle.Timeline.create_transition(transition_attrs
    |> Map.put(:phase_id, p.id)
    )
  end
end
