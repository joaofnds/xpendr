defmodule XpendrWeb.UserView do
  use XpendrWeb, :view

  alias Xpendr.Accounts.User

  def wallets(%User{wallets: wallets} = user) do
    wallets
  end
end
