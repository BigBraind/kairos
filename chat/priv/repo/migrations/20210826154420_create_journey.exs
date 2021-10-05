defmodule Chat.Repo.Migrations.CreateJourney do
  use Ecto.Migration

  def change do
    create table(:journey) do
      add :name, :string, null: false, size: 30
      add :type, :string

      timestamps()
    end

    #create unique_index(:journey, [:id])
  end
end
