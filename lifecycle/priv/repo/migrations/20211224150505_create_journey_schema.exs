defmodule Lifecycle.Repo.Migrations.CreateJourneySchema do
  use Ecto.Migration

  def change do
    create table(:journeys, primary_key: false) do
      add :journey_id, :binary_id, primary_key: true
      add :journey_type, :string
      add :journey_title, :string
      add :journey_content, :string
      add :parent_journey, references(:journeys, column: :journey_id, on_delete: :nothing, type: :binary_id)
      add :child_journey, references(:journeys, column: :journey_id, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:journeys, [:parent_journey])
    create index(:journeys, [:child_journey])

  end
end
