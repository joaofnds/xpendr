defmodule Xpendr.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :type, :string
      add :amount, :integer, default: 0
      add :description, :text
      add :wallet_id, references(:wallets, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:transactions, [:wallet_id])
  end
end
