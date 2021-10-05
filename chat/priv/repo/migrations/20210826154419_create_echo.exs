defmodule Chat.Repo.Migrations.CreateEcho do
  use Ecto.Migration

  def change do
    create table(:echo) do
      add :type, :string
      add :journey, :string
      #add :user_id, references("users", type: :uuid)
      add :name, :string
      add :message, :string

      timestamps()
    end

  end
end
