defmodule Chat.Repo.Migrations.BrandNewRevision do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :username, :string
      add :password_hash, :string, redact: true
      add :email, :string
      timestamps()
    end

    create table(:events, primary_key: false) do
      add :eventID, :integer, primary_key: true
      add :eventType, :string
      timestamps()
    end

    create table(:mushrooms, primary_key: false) do
      add :mushroomID, :int, primary_key: true
      add :mushroomType, :string
      add :user, references("users", type: :uuid)
      add :state, :string
      timestamps()
    end

    create table(:mushroom_events, primary_key: false) do
      add :id, :int, primary_key: true
      add :mushroomID, references("mushrooms", column: :mushroomID, type: :int)
      add :eventID, references("events", column: :eventID)
      timestamps()
    end

    create table(:messages, primary_key: false) do
      add :messageID, :integer, primary_key: true
      add :eventID, references("events", column: :eventID)
      add :lobbyID, :integer
      add :message, :string
      add :image, :string
      timestamps()
    end

    create table(:transactions) do
      add :transactionID, :integer, primary_key: true
      add :mushroomID, references("mushrooms", column: :mushroomID, type: :integer)
      add :buyer, references("users", type: :uuid)
      add :seller, references("users", type: :uuid)
      add :eventID, references("events", column: :eventID)
    end

  end
end
