defmodule Lifecycle.Repo.Migrations.Transition do
  use Ecto.Migration

  def change do
    create table(:transition, primary_key: :false) do
      add :id, :binary_id, primary_key: true
      add :qna, :map, default: %{}
      timestamps()
    end
  end
end
