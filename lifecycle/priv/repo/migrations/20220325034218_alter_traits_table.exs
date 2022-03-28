defmodule Lifecycle.Repo.Migrations.AlterTraitsTable do
  use Ecto.Migration

  def change do
    alter table("traits") do
      modify :value, :string
      modify :type, :trait_type, null: false
    end
  end
end
