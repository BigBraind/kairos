defmodule Lifecycle.Bridge.PhaseUser do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lifecycle.Timeline.User
  alias Lifecycle.Timeline.Party

  schema "phase_user_link" do
    belongs_to :phase, Phase
    belongs_to :user, User
    # timestamps()
  end

  def changeset(link, attrs \\ ${}) do
    link
    |> cast(attrs, [:phase, :user])
    |> validate_required([:phase, :user])
  end
end
