defmodule Lifecycle.Repo.Migrations.PartyUserLink do
  use Ecto.Migration

  def change do
    create table(:party_user_link, primary_key: :false) do
      add :party_id, references(:parties, column: :id, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, column: :id, on_delete: :nothing, type: :binary_id)
    end

    create index(:party_user_link, [:party_id, :user_id])
  end
end
