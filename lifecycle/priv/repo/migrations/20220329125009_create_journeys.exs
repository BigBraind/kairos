defmodule Lifecycle.Repo.Migrations.CreateJourneys do
  use Ecto.Migration

  def change do
    alter table(:journeys, primary_key: false) do
      add :name, :string
    end

    create index(:journeys, [:party_id])
    #create index(:journeys, [:transitions])
  end
end
