defmodule Lifecycle.Repo.Migrations.PhasesLink do
  use Ecto.Migration

  def change do
    # many_to_many :parent_of, UserRelations.Accounts.Person, join_through: "relationships", join_keys: [parent_id: :id, child_id: :id]
    # many_to_many :child_of, UserRelations.Accounts.Person, join_through: "relationships", join_keys: [child_id: :id, parent_id: :id]
    create table(:phase_phase_link, primary_key: false) do
      add :parent_id, references(:phases, column: :id, on_delete: :delete_all, type: :binary_id)
      add :child_id, references(:phases, column: :id, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
    create index(:phase_phase_link, [:parent_id, :child_id])
    create index(:phase_phase_link, [:child_id, :parent_id])
  end
end
