defmodule Lifecycle.Repo.Migrations.CreateEchoes do
  use Ecto.Migration

  def change do
    create table(:echoes) do
      add :message, :string
      add :journey, :string
      add :type, :string
      add :name, :string

      timestamps()
    end
  end
end
