defmodule XpendrWeb.Resolvers.Accounts do
  alias Xpendr.Accounts

  def list_users(_parent, _args, _resolution) do
    {:ok, Accounts.list_users()}
  end
end
