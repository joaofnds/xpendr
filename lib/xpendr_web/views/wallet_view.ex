defmodule XpendrWeb.WalletView do
  use XpendrWeb, :view

  alias Xpendr.Finance.Wallet

  def owner_name(%Wallet{user: user} = wallet) do
    user.name
  end

  def owner_username(%Wallet{user: user} = wallet) do
    user.username
  end
end
