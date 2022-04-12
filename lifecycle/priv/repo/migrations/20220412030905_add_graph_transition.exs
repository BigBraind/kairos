defmodule Lifecycle.Repo.Migrations.AddGraphTransition do
  use Ecto.Migration

  def change do
    update_query = "ALTER TYPE trait_type ADD VALUE 'graph' AFTER 'bool'"
    execute(update_query)

    alter table(:journeys, primary_key: false) do
      add :name, :string
      add :realm_id, references("realms", column: :id, type: :binary_id, on_delete: :nilify_all)
    end

    alter table(:realms, primary_key: false) do
      add :party_id, references("parties", column: :id, type: :binary_id, on_delete: :nilify_all)
    end

    create index(:journeys, [:realm_id])
    create index(:realms, [:party_id])
    create unique_index(:realms, [:name, :party_id], name: :unique_realms)
  end
end
