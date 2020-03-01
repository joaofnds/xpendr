defmodule XpendrWeb.Schema.FinanceTypes do
  use Absinthe.Schema.Notation

  object :wallet do
    field :id, :id
    field :balance, :integer
    field :description, :string
    field :name, :string

    field :transactions, list_of(:transaction)
    field :user, :user
  end

  object :transaction do
    field :id, :id
    field :amount, :integer
    field :description, :string
    field :type, :string
    field :wallet, :wallet
  end
end
