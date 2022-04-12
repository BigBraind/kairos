defmodule Lifecycle.Repo.Migrations.AddGraphTransition do
  use Ecto.Migration

  def change do
    update_query = "ALTER TYPE trait_type ADD VALUE 'graph' AFTER 'bool'"
    execute(update_query)
  end
end
