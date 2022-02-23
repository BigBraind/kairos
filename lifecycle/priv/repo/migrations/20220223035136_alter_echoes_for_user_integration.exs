defmodule Lifecycle.Repo.Migrations.AlterEchoesForUserIntegration do
  use Ecto.Migration

  def change do
    alter table("echoes") do
      remove :transited #remove/abstract out to transition object
      remove :transiter #remove/abstract out to transition object
      modify :name, references("users", column: :name, type: :string, on_delete: :nilify_all) #change reference towards table rather than pulling name from ws

    end
  end
end
