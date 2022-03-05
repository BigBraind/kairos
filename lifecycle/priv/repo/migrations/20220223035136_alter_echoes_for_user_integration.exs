defmodule Lifecycle.Repo.Migrations.AlterEchoesForUserIntegration do
  use Ecto.Migration

  def change do
    alter table("echoes") do
      remove :transited #remove/abstract out to transition object
      remove :transiter #remove/abstract out to transition object
      remove :name
      add :poster_id, references("users", column: :id, type: :binary_id, on_delete: :nilify_all) #change reference towards table rather than pulling name from ws

    end
  end
end
