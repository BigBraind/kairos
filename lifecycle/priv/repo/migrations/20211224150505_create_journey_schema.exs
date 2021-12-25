defmodule Lifecycle.Repo.Migrations.CreateJourneySchema do
  use Ecto.Migration

  def change do
    create table(:journeys, primary_key: false) do
      add :journey_id, :binary_id, primary_key: true
      add :journeyType, :string
      add :journeyTitle, :string
      add :journeyContent, :string
      add :parentJourney, references(:journeys, column: :journey_id, on_delete: :nothing, type: :binary_id)
      add :childJourney, references(:journeys, column: :journey_id, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:journeys, [:parentJourney])
    create index(:journeys, [:childJourney])

  end
end
