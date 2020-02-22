defmodule XpendrWeb.TransactionView do
  use XpendrWeb, :view

  def wallet_select(form, field, wallets) do
    select(form, field, Enum.map(wallets, &{&1.name, &1.id}))
  end

  def transaction_select(form, field) do
    select(form, field, transaction_types())
  end

  def transaction_types do
    Xpendr.Finance.Transaction.types()
  end

  def wallet_name(transaction) do
    transaction.wallet.name
  end
end
