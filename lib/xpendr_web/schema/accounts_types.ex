defmodule XpendrWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  @desc "A user represents a person that has wallets"
  object :user do
    field :id, :id
    field :name, :string
    field :username, :string
  end
end
