defmodule Chat.Repo.Migrations.BrandNewRevision do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :userID, :uuid, primary_key: true
      add :email, :string, null: false
      add :username, :string
      add :password_hash, :string, redact: true
      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])

    create table(:growthStats, primary_key: false) do
      add :growthStatsID, :uuid, primary_key: true
      add :waterInML, :decimal
      add :honeyInML, :decimal
      add :statsJSON, :map
      add :username, references("users", column: :username, type: :string)
    end

    create table(:mushrooms, primary_key: false) do
      add :mushroomID, :uuid, primary_key: true
      add :mushroomType, :string
      add :users, references("users", column: :username, type: :string)
      timestamps()
    end


    create table(:nodes, primary_key: false) do
      add :nodeID, :uuid, primary_key: true
      add :parentNode, references("nodes", column: :nodeID, type: :uuid)
      add :childNode, references("nodes", column: :nodeID, type: :uuid)
      add :nodeType, :string, null: false
      add :mushroomID, {:array, :uuid}, default: fragment("ARRAY[]::uuid[]")
      add :growthStatsID, references("growthStats", column: :growthStatsID, type: :uuid)
    end

    create unique_index(:nodes, [:nodeType])

    create table(:events, primary_key: false) do
      add :eventID, :uuid, primary_key: true
      add :username, references("users", column: :username, type: :string)
      add :nodeID, references("nodes", column: :nodeID, type: :uuid)
    end

    create table(:echo, primary_key: false) do
      add :echoID, references("events", column: :eventID, type: :uuid), primary_key: true
      add :journey, references("nodes", column: :nodeType, type: :string)
      add :lobby, :string
      add :name, :string
      add :message, :string

      timestamps()
    end

    create table(:transitions, primary_key: false) do
      add :transitionID, references("events", column: :eventID, type: :uuid), primary_key: true
      add :currentNode, references("nodes", column: :nodeID, type: :uuid)
      add :nextNode, references("nodes", column: :nodeID, type: :uuid)
      add :approvalBy, references("users", column: :username, type: :string)
    end

    create table(:transactions, primary_key: false) do
      add :transactionID, references("events", column: :eventID, type: :uuid), primary_key: true
      add :mushroomID, references("mushrooms", column: :mushroomID, type: :uuid)
      add :buyer, references("users", column: :username, type: :string)
      add :seller, references("users", column: :username, type: :string)

    end
  end
end
