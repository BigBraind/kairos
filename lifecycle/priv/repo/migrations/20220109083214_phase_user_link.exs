defmodule Lifecycle.Repo.Migrations.PhaseUserLink do
  use Ecto.Migration

  def change do
    create table(:phase_user_link, primary_key: false) do
      add :phase, references(:phases, column: :id, on_delete: :delete_all, type: :binary_id)
      add :user, references(:users, column: :id, on_delete: :delete_all, type: :binary_id)
    end
  end
end
