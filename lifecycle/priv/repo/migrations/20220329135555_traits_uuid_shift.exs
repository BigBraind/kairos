defmodule Lifecycle.Repo.Migrations.TraitsUuidShift do
  use Ecto.Migration

  def change do
    drop table("traits"), mode: :cascade
    create table(:traits, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :value, :string
      add :type, :trait_type, null: false
      add :unit, :string
      add :phase_id, references(:phases, type: :binary_id, on_delete: :delete_all)
      timestamps()
    end

    create index(:traits, [:phase_id])
    create unique_index(:traits, [:name, :type, :phase_id], name: :repeat_traits)
  end
end
