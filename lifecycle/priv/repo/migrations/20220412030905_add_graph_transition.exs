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
      add :party_name, references("parties", column: :name, type: :string, on_delete: :nilify_all)
    end

    create index(:journeys, [:realm_id])
    create index(:realms, [:party_name])
    drop unique_index(:realms, [:name]) ## remove older name index to unique realms per party
    create unique_index(:realms, [:name, :party_name], name: :unique_realms)
  end
end
