defmodule Lifecycle.Repo.Migrations.CreateTraits do
  use Ecto.Migration

  def change do
    create_query = "CREATE TYPE trait_type AS ENUM ('num', 'txt', 'img', 'bool')"
    drop_query = "DROP TYPE trait_type"
    execute(create_query, drop_query)

    create table(:traits) do
      add :name, :string
      add :value, :string, null: false
      add :type, :trait_type
      add :unit, :string
      add :phase_id, references(:phases,type: :binary_id, on_delete: :delete_all)

      timestamps()
    end

    create index(:traits, [:phase_id])
    unique_index(:traits, [:name, :value, :phase_id])
  end
end
