defmodule XpendrWeb.Schema do
  use Absinthe.Schema

  import_types(XpendrWeb.Schema.AccountsTypes)

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve(&XpendrWeb.Resolvers.Accounts.list_users/3)
    end
  end
end
