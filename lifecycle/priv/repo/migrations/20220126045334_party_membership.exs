defmodule Lifecycle.Repo.Migrations.PartyMembership do
  use Ecto.Migration

  def change do

    create_query = "CREATE TYPE party_role AS ENUM ('lead', 'whip', 'pleb')"
    drop_query = "DROP TYPE party_role"
    execute(create_query, drop_query)

    create table(:party_membership, primary_key: :false) do
      add :party_id, references(:parties, column: :id, on_delete: :delete_all, type: :binary_id)
      add :user_id, references(:users, column: :id, on_delete: :nothing, type: :binary_id)
      add :role, :party_role
      timestamps()
    end

    create unique_index(:party_membership, [:party_id, :user_id])
    create unique_index(:party_membership, [:user_id, :party_id], name: :my_membership)
  end
end
