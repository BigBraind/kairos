defmodule Lifecycle.Repo.Migrations.CreateParties do
  use Ecto.Migration

  def change do
    create table(:parties, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :owner, references(:users, column: :id, on_delete: :nothing, type: :binary_id)

      timestamps()
    end
  end
end
