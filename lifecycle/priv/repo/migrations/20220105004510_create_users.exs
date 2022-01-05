defmodule Lifecycle.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :password_hash, :string, redact: true

      timestamps()
    end
    create unique_index(:users, [:name])
  end
end
