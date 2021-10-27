defmodule Chat.Repo.Migrations.AddMushroomJourneyRelationship do
  use Ecto.Migration

  def change do
    alter table(:journey) do
      add :mushroomID, references("mushrooms", column: :mushroomID, type: :integer)
    end
  end
end
