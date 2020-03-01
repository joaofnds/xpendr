defmodule XpendrWeb.Schema do
  use Absinthe.Schema

  import_types(XpendrWeb.Schema.AccountsTypes)
  import_types(XpendrWeb.Schema.FinanceTypes)

  query do
    @desc "Get all users"
    field :users, list_of(:user) do
      resolve(&XpendrWeb.Resolvers.Accounts.list_users/3)
    end

    field :credentials, list_of(:credential) do
      resolve(&XpendrWeb.Resolvers.Accounts.list_credentials/3)
    end

    field :wallets, list_of(:wallet) do
      resolve(&XpendrWeb.Resolvers.Finance.list_wallets/3)
    end
  end
end
