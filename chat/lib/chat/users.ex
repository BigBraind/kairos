defmodule Chat.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:uuid, :binary_id, autogenerate: true}
  schema "users" do
    field :username, :string
    field :password, :string
    field :email, :string
    field :secret_question, :string
    field :secret_answer, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email, :secret_question, :secret_answer])
    |> validate_required([:username, :password, :email, :secret_question, :secret_answer])
  end

end
