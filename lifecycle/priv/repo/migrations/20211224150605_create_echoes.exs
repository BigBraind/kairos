defmodule Lifecycle.Repo.Migrations.CreateEchoes do
  use Ecto.Migration

  def change do
    create table(:echoes) do
      add :message, :string
      add :journey, references("journeys", column: :journey_id, type: :binary_id)
      add :type, :string
      add :name, :string

      timestamps()
    end
  end
end
