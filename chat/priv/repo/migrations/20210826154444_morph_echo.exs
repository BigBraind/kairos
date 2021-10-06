defmodule Chat.Repo.Migrations.MorphEcho do
  use Ecto.Migration

  def change do
    alter table(:echo) do
      remove :lobby, :string
      add :journey, :string
      #add :user_id, references("users", type: :uuid)
    end
  end
end
