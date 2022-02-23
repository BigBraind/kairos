defmodule Lifecycle.Repo.Migrations.AlterPhasesForQTemplate do
  use Ecto.Migration

  def change do
    alter table("phases") do
      add :template, :map, default: %{} #json with empty strings
    end
  end
end
