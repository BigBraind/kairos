defmodule Lifecycle.Timeline.Transition do
  @moduledoc """
    Schema table for Phase Objects
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Timeline.Phase
  alias Lifecycle.Users.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "transition" do
    belongs_to :user, Lifecycle.Users.User, foreign_key: :transit_id
    belongs_to :phase, Lifecycle.Timeline.Phase, foreign_key: :phase_id
    field :transited, :boolean
    # field :transiter, :string
    belongs_to :transiter, Lifecycle.Users.User, foreign_key: :transiter_id
    field :answers, :map
    timestamps()
  end

  @doc false
  def changeset(transition, attrs) do
    transition
    |> cast(attrs, [:transited, :transiter, :answers])
  end
end
