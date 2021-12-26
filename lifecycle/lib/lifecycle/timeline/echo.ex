defmodule Lifecycle.Timeline.Echo do
  use Ecto.Schema
  import Ecto.Changeset


  schema "echoes" do
    belongs_to :journey, Lifecycle.Timeline.Journey
    field :message, :string
    field :name, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(echo, attrs \\ %{}) do
    echo
    |> cast(attrs, [:message, :journey_id, :type, :name])
    # |> cast_assoc(attrs, [:id])
    |> validate_required([:message, :name])
    # |> validate_required([:message, :journey, :type, :name])
  end
end

# new_attrs = %{journeyType: "testType", journeyTitle: "testTitle", journeyContent: "testContent", id: Ecto.UUID.generate()}
# {:ok, journey} = Lifecycle.Timeline.create_journey(new_attrs)
# echo_attrs = %{message: "testMessage", journey: "", type: "testType", name: "testName"}
