defmodule XpendrWeb.Resolvers.Finance do
  alias Xpendr.Finance

  def list_wallets(_parent, _args, %{context: %{current_user: user}}) do
    {:ok, Finance.user_wallets(user.id)}
  end
end
