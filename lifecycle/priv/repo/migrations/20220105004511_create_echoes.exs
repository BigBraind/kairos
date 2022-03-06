defmodule Lifecycle.Repo.Migrations.CreateEchoes do
  use Ecto.Migration

  def change do
    create table(:echoes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :message, :string
      add :phase_id, references("phases", column: :id, type: :binary_id, on_delete: :delete_all)
      add :type, :string
      add :user_name, references("users", column: :name, type: :string, on_delete: :nilify_all)
      timestamps()
    end
  end
end
