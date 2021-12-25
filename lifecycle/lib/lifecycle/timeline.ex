defmodule Lifecycle.Timeline do
  @moduledoc """
  The Timeline context.
  """

  import Ecto.Query, warn: false
  alias Lifecycle.Repo

  alias Lifecycle.Timeline.Echo

  alias Lifecycle.Pubsub


  # @topic inspect(__MODULE__)

  @doc """
  Returns the list of echoes.

  ## Examples

      iex> list_echoes()
      [%Echo{}, ...]

  """
  def list_echoes do
    Repo.all(Echo)
  end

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

  def journey_call(journey) do
    query=from(e in Lifecycle.Echo, where: e.journey == ^journey , order_by: [desc: e.inserted_at])
    Lifecycle.Repo.all(query, limit: 8)
  end

  # defp notify_subs({:ok, result}, event) do
  #   Phoenix.PubSub.broadcast(Lifecycle.PubSub, @topic, {__MODULE__, event, result})
  #   {:ok, result}
  # end

  # defp notify_subs({:error, reason}, _event) do
  #   {:error, reason}
  # end
end
