defmodule Lifecycle.Timeline.Phase do
  @moduledoc """
    Schema table for Phase Objects
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Lifecycle.Bridge.Phasor
  alias Lifecycle.Repo
  alias Lifecycle.Timeline.Phase
  alias Lifecycle.Timeline.Phase.Trait

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "phases" do
    field :content, :string
    field :title, :string
    field :type, :string
    # field :parent, :binary_id
    # field :child, :binary_id
    has_many :echoes, Lifecycle.Timeline.Echo, foreign_key: :phase_id
    has_many :traits, Trait, foreign_key: :phase_id
    many_to_many :child, Phase, join_through: Phasor, join_keys: [parent_id: :id, child_id: :id]
    many_to_many :parent, Phase, join_through: Phasor, join_keys: [child_id: :id, parent_id: :id]

    timestamps()
  end

  @max_len 21

  @doc false
  def changeset(phase, attrs) do
    phase
    |> cast(attrs, [:content, :title, :type])
    |> cast_assoc(:traits, on_replace: :delete_if_exists)
    |> validate_length(:title, max: @max_len)
    |> validate_required([:content, :title, :type])
  end

  @doc """
  Returns the list of traits.

  ## Examples

      iex> list_traits()
      [%Trait{}, ...]

  """
  def list_traits(phase_id) do
    from(t in Trait, where: [phase_id: ^phase_id], order_by: [asc: :id])
    |> Repo.all()
  end

  @doc """
  Gets a single trait.

  Raises `Ecto.NoResultsError` if the Trait does not exist.

  ## Examples

      iex> get_trait!(123)
      %Trait{}

      iex> get_trait!(456)
      ** (Ecto.NoResultsError)

  """
  def get_trait!(phase_id, id), do: Repo.get_by!(Trait, phase_id: phase_id, id: id)
  def get_trait!(phase_id, name, type), do: Repo.get_by!(Trait, phase_id: phase_id, name: name, type: type)

  @doc """
  Creates a trait.

  ## Examples

      iex> create_trait(%{field: value})
      {:ok, %Trait{}}

      iex> create_trait(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_trait(attrs \\ %{}, %Phase{} = phase) do
    phase
    |> Ecto.build_assoc(:traits)
    |> Trait.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a trait.

  ## Examples

      iex> update_trait(trait, %{field: new_value})
      {:ok, %Trait{}}

      iex> update_trait(trait, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_trait(%Trait{} = trait, attrs) do
    trait
    |> Trait.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a trait.

  ## Examples

      iex> delete_trait(trait)
      {:ok, %Trait{}}

      iex> delete_trait(trait)
      {:error, %Ecto.Changeset{}}

  """
  def delete_trait(%Trait{} = trait) do
    Repo.delete(trait)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking trait changes.

  ## Examples

      iex> change_trait(trait)
      %Ecto.Changeset{data: %Trait{}}

  """
  def change_trait(%Trait{} = trait, attrs \\ %{}) do
    Trait.changeset(trait, attrs)
  end
end
