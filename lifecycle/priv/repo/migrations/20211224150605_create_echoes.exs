defmodule Lifecycle.Repo.Migrations.CreateEchoes do
  use Ecto.Migration

  def change do
    create table(:echoes) do
      add :message, :string
      add :phase_id, references("phases", column: :id, type: :binary_id, on_delete: :delete_all)
      add :type, :string
      add :name, :string
      add :transited , :boolean
      add :transiter , :string

      timestamps()
    end
  end
end
