defmodule Lifecycle.Repo.Migrations.CreateProfile do
  use Ecto.Migration

  def change do
    create table(:transition, primary_key: :false) do
      add :id, :binary_id, primary_key: true
      add :username, :string, null: false
      add :email, :string, null: false

      timestamps()
    end
  end
end
