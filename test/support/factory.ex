defmodule Xpendr.Factory do
  use ExMachina.Ecto, repo: Xpendr.Repo

  alias Xpendr.Accounts.User
  alias Xpendr.Finance.{Wallet, Transaction}

  def user_factory do
    %User{
      name: "John Doe",
      username: sequence("username")
    }
  end

  def wallet_factory do
    %Wallet{
      user: build(:user),
      name: "some name",
      balance: 100_00,
      description: "some description"
    }
  end

  def transaction_factory do
    %Transaction{
      wallet: build(:wallet),
      type: sequence(:type, [Transaction.types()]),
      amount: 10_00,
      description: "some description"
    }
  end
end
