defmodule Lifecycle.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias Lifecycle.Repo

  alias Lifecycle.Timeline.Echo
  alias Lifecycle.Timeline.Phase
  alias Lifecycle.Timeline.Transition
  alias Lifecycle.Bridge.Phasor
  alias Lifecycle.Users.User

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
  Returns an `%Ecto.Changeset{}` for tracking echo changes.

  ## Examples

      iex> change_echo(echo)
      %Ecto.Changeset{data: %Echo{}}

  """
  def change_echo(%Echo{} = echo, attrs \\ %{}) do
    Echo.changeset(echo, attrs)
  end

  def recall(limit \\ 8) do
    query = from(e in Echo, order_by: [desc: e.inserted_at])
    Lifecycle.Repo.all(query, limit: limit)
  end

  def phase_recall(id) do
    query = from(e in Echo, where: e.phase_id == ^id, order_by: [desc: e.inserted_at])
    Lifecycle.Repo.all(query, limit: 8)
  end

  @doc """
    Approve the transition echo objects

    A wrapper of update_echo
  """

  # def update_transition(id, attrs), do: update_echo(get_echo!(id), attrs)

  @doc """
  Returns the list of phases.

  ## Examples

      iex> list_phases()
      [%Phase{}, ...]

  """
  def list_phases do
    Repo.all(from(p in Phase, preload: [:parent, :child]))
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
  def get_phase!(id), do: Repo.get!(Phase, id) |> Repo.preload([:parent, :child, :traits])

  @doc """
  Creates a phase.

  ## Examples

      iex> create_phase(%{field: value})
      {:ok, %Phase{}}

      iex> create_phase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phase(attrs \\ %{}) do
    case attrs do
      %{"parent" => parent_id} ->
        {:ok, phase} =
          %Phase{}
          |> Phase.changeset(attrs)
          |> Repo.insert()

        %Phasor{}
        |> Phasor.changeset(%{parent_id: parent_id, child_id: phase.id})
        |> Repo.insert()

        {:ok, phase}

      %{} ->
        %Phase{}
        |> Phase.changeset(attrs)
        |> Repo.insert()
    end
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

  def create_transition(attrs \\ %{}) do
    %Transition{}
    |> Transition.changeset(attrs)
    |> Repo.insert()
  end

  def update_transition(%Transition{} = transition, attrs) do
    transition
    |> Transition.changeset(attrs)
    |> Repo.update()
  end

  def get_transition_list(id) do
    query =
      Transition
      |> where([e], e.phase_id == ^id)
      |> order_by([e], desc: e.inserted_at)
      |> preload([:transiter, :initiator])

    Repo.all(query, limit: 8)
  end

  def get_transition_by_id(id), do: Repo.get!(Transition, id) |> Repo.preload([:transiter, :initiator])

  def change_transition(%Transition{} = transition, attrs \\ %{}) do
    Transition.changeset(transition, attrs)
  end

  def get_user_by_id(id), do: Repo.get!(User, id) |> preload([:transiter, :initiator])

  def delete_transition(%Transition{} = transition), do: Repo.delete(transition)
end
