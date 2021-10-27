defmodule Chat.Repo.Migrations.AddMushroomTable do
  use Ecto.Migration

  def change do
    create table(:mushrooms, primary_key: false) do
      add :mushroomID, :int, primary_key: true
      add :mushroomType, :string
      add :user, references("users", type: :integer)
      add :state, :string
      timestamps()
    end
  end
end
