defmodule Lifecycle.Repo.Migrations.AlterJourneyUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:realms, [:name])
    alter table(:journeys) do
      add :realm_name, references(:realms, column: :name, on_delete: :nothing, type: :string)
      add :pointer,:integer
      remove :realm_id
    end
    create unique_index(:journeys, [:realm_name, :pointer], name: :realm_journey_index)
  end
end
