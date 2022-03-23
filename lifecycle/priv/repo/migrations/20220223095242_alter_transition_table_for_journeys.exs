defmodule Lifecycle.Repo.Migrations.AlterTransitionTableForJourneys do
  use Ecto.Migration

  def change do
    alter table("transitions") do
      add :journey_id, references("journeys", column: :id, type: :binary_id, on_delete: :delete_all)

    end
  end
end
