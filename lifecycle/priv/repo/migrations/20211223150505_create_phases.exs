defmodule Lifecycle.Repo.Migrations.CreatePhases do
  use Ecto.Migration

  def change do
    create table(:phases, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :title, :string
      add :type, :string
      # add :parent, references(:phases, column: :id, on_delete: :nothing, type: :binary_id)
      # add :child, references(:phases, column: :id, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    # create index(:phases, [:parent])
    # create index(:phases, [:child])
  end
end
