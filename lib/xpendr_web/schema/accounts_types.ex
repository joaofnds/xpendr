defmodule XpendrWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  @desc "A user represents a person that has wallets"
  object :user do
    field :id, :id
    field :name, :string
    field :username, :string
    field :credentials, list_of(:credential)
  end

  object :credential do
    field :id, :id
    field :password, :string
    field :user, :user
  end
end
