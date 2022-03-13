defmodule Lifecycle.Repo.Migrations.CreateRealmTable do
  use Ecto.Migration

  def change do
    create table (:realms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string
      timestamps()
    end

    create unique_index (:realms, [:name])
  end
end
