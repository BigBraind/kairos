defmodule Lifecycle.Repo.Migrations.CreatePhases do
  use Ecto.Migration

  def change do
    create table(:phases, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :title, :string
      add :type, :string
      timestamps()
    end
  end
end
