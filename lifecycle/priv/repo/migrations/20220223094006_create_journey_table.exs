defmodule Lifecycle.Repo.Migrations.CreateJourneyTable do
  use Ecto.Migration

  def change do
    create table(:journeys, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :party_id, references("parties", column: :id, type: :binary_id, on_delete: :nilify_all)
      timestamps()
    end
  end
end
