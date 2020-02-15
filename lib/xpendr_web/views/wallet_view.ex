defmodule XpendrWeb.WalletView do
  use XpendrWeb, :view

  alias Xpendr.Finance.Wallet

  def owner_name(%Wallet{user: user}) do
    user.name
  end

  def owner_username(%Wallet{user: user}) do
    user.username
  end

  def transactions(%Wallet{transactions: transactions}) do
    transactions
  end
end
