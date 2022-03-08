defmodule Lifecycle.Repo.Migrations.Transition do
  use Ecto.Migration

  def change do
    create table(:transitions, primary_key: :false) do
      add :id, :binary_id, primary_key: true
      add :initiator_id, references(:users, column: :id, type: :binary_id, on_delete: :nilify_all)
      add :phase_id, references(:phases, column: :id, type: :binary_id, on_delete: :delete_all)
      add :answers, :map, default: %{}
      add :transited, :boolean
      add :transiter_id, references(:users, column: :id, type: :binary_id, on_delete: :nilify_all)
      timestamps()
    end
  end
end
