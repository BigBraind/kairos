defmodule Chat.Repo.Migrations.MorphJourney do
  use Ecto.Migration

  def change do
    alter table(:journey) do
      add :parent_journey, references("journey")
      add :children_journey, references("journey")
    end
  end
end
