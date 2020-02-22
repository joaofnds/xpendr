defmodule Xpendr.Factory do
  use ExMachina.Ecto, repo: Xpendr.Repo

  alias Xpendr.Accounts.{User, Credential}
  alias Xpendr.Finance.{Wallet, Transaction}

  def user_factory do
    %User{
      name: "John Doe",
      username: sequence("username")
    }
  end

  def credential_factory do
    %Credential{
      user: build(:user),
      password: "s0m3s3cr3tp4ssw04d"
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
      type: sequence(:type, Map.values(Transaction.types())),
      amount: 10_00,
      description: "some description"
    }
  end
end
