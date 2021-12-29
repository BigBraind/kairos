defmodule Lifecycle.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias Lifecycle.Repo

  alias Lifecycle.Timeline.Echo

  alias Lifecycle.Timeline.Journey
  alias Lifecycle.Pubsub

  # @topic inspect(__MODULE__)

  @doc """
  Returns the list of echoes.

  ## Examples

      iex> list_echoes()
      [%Echo{}, ...]

  """
  def list_echoes, do: Repo.all(Echo)


  @doc """
  Gets a single echo.

  Raises `Ecto.NoResultsError` if the Echo does not exist.

  ## Examples

      iex> get_echo!(123)
      %Echo{}

      iex> get_echo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_echo!(id), do: Repo.get!(Echo, id)

  @doc """
  Creates a echo.

  ## Examples

      iex> create_echo(%{field: value})
      {:ok, %Echo{}}

      iex> create_echo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_echo(attrs \\ %{}) do
    %Echo{}
    |> Echo.changeset(attrs)
    |> Repo.insert()
    # |> Pubsub.notify_subs([:echo, :created])
  end

  @doc """
  Updates a echo.

  ## Examples

      iex> update_echo(echo, %{field: new_value})
      {:ok, %Echo{}}

      iex> update_echo(echo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_echo(%Echo{} = echo, attrs) do
    echo
    |> Echo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a echo.

  ## Examples

      iex> delete_echo(echo)
      {:ok, %Echo{}}

      iex> delete_echo(echo)
      {:error, %Ecto.Changeset{}}

  """

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking echo changes.

  ## Examples

      iex> change_echo(echo)
      %Ecto.Changeset{data: %Echo{}}

  """
  def change_echo(%Echo{} = echo, attrs \\ %{}) do
    Echo.changeset(echo, attrs)
  end

  def recall(limit \\ 8) do
    query=from(e in Echo, order_by: [desc: e.inserted_at])
    Lifecycle.Repo.all(query, limit: limit)
  end

  def phase_recall(id) do
    query=from(e in Echo, where: e.phase_id == ^id , order_by: [desc: e.inserted_at])
    Lifecycle.Repo.all(query, limit: 8)
  end

  def list_journeys, do: Repo.all(Journey)

  @doc """
  Creates a echo.

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
    # |> notify_subs([:journey, :created])
  end

  def get_journey!(id), do: Repo.get!(Journey, id)

  def change_journey(%Journey{} = journey, attrs \\ %{}) do
    Journey.changeset(journey, attrs)
  end

  def update_journey(%Journey{} = journey, attrs) do
    journey
    |> Journey.changeset(attrs)
    |> Repo.update()
  end


  alias Lifecycle.Timeline.Phase

  @doc """
  Returns the list of phases.

  ## Examples

      iex> list_phases()
      [%Phase{}, ...]

  """
  def list_phases do
    Repo.all(Phase)
  end

  @doc """
  Gets a single phase.

  Raises `Ecto.NoResultsError` if the Phase does not exist.

  ## Examples

      iex> get_phase!(123)
      %Phase{}

      iex> get_phase!(456)
      ** (Ecto.NoResultsError)

  """
  def get_phase!(id), do: Repo.get!(Phase, id)

  @doc """
  Creates a phase.

  ## Examples

      iex> create_phase(%{field: value})
      {:ok, %Phase{}}

      iex> create_phase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phase(attrs \\ %{}) do
    %Phase{}
    |> Phase.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a phase.

  ## Examples

      iex> update_phase(phase, %{field: new_value})
      {:ok, %Phase{}}

      iex> update_phase(phase, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_phase(%Phase{} = phase, attrs) do
    phase
    |> Phase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a phase.

  ## Examples

      iex> delete_phase(phase)
      {:ok, %Phase{}}

      iex> delete_phase(phase)
      {:error, %Ecto.Changeset{}}

  """
  def delete_phase(%Phase{} = phase) do
    Repo.delete(phase)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phase changes.

  ## Examples

      iex> change_phase(phase)
      %Ecto.Changeset{data: %Phase{}}

  """
  def change_phase(%Phase{} = phase, attrs \\ %{}) do
    Phase.changeset(phase, attrs)
  end
end
