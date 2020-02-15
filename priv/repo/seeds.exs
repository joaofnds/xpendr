# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Xpendr.Repo.insert!(%Xpendr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Xpendr.Accounts
alias Xpendr.Finance

{:ok, user} =
  Accounts.create_user(%{
    name: "joao fernandes",
    username: "joaofnds"
  })

{:ok, wallet} =
  Finance.create_wallet(%{
    user_id: user.id,
    name: "NuBank"
  })

{:ok, _} =
  Finance.create_transaction(%{
    wallet_id: wallet.id,
    type: "income",
    amount: 10_00
  })
