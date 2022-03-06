defmodule Lifecycle.Repo.Migrations.CreateTraits do
  use Ecto.Migration

  def change do
    create table(:traits) do
      add :name, :string
      add :value, :string, null: false
      add :type, :string
      add :unit, :string
      add :phase_id, references(:phases,type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create index(:traits, [:phase_id])
    unique_index(:traits, [:name, :value, :product_id])
  end
end
