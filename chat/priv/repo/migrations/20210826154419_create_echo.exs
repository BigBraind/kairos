defmodule Chat.Repo.Migrations.CreateEcho do
  use Ecto.Migration

  def change do
    create table(:echo) do
      add :type, :string
      add :lobby, :string
      add :name, :string
      add :message, :string

      timestamps()
    end

  end
end
