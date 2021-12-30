defmodule Lifecycle.Timeline.Echo do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id
  schema "echoes" do
    field :message, :string
    field :name, :string
    field :type, :string
    belongs_to :phase, Lifecycle.Timeline.Phase, foreign_key: :phase_id
    timestamps()
  end

  @doc false
  def changeset(echo, attrs \\ %{}) do
    echo
    |> cast(attrs, [:message, :phase_id, :type, :name])
    # |> cast_assoc(attrs, [:journey])
    |> validate_required([:message, :name])
    # |> validate_required([:message, :journey, :type, :name])
  end
end

# new_attrs = %{journeyType: "testType", journeyTitle: "testTitle", journeyContent: "testContent", id: Ecto.UUID.generate()}
# {:ok, journey} = Lifecycle.Timeline.create_journey(new_attrs)
# echo_attrs = %{message: "testMessage", journey: "", type: "testType", name: "testName"}
