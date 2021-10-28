defmodule Lifecycle.Timeline.Echo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "echoes" do
    field :journey, :string
    field :message, :string
    field :name, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(echo, attrs \\ %{}) do
    echo
    |> cast(attrs, [:message, :journey, :type, :name])
    |> validate_required([:message, :name])
    # |> validate_required([:message, :journey, :type, :name])
  end
end
