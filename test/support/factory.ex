defmodule Xpendr.Factory do
  alias Xpendr.Repo

  alias Xpendr.Accounts.User
  alias Xpendr.Finance.{Wallet, Transaction}

  def build(:wallet_with_user) do
    user = insert!(:user)
    insert!(:wallet, user.id)
  end

  def build(:user) do
    %User{name: "some name", username: "some username"}
  end

  def build(:wallet, user_id) do
    %Wallet{
      user_id: user_id,
      name: "some name",
      balance: 100_00,
      description: "some description"
    }
  end

  def build(:transaction, wallet_id) do
    %Transaction{
      wallet_id: wallet_id,
      type: "income",
      amount: 10_00,
      description: "some description"
    }
  end

  def build(factory, attributes) do
    build(factory) |> struct(attributes)
  end

  def insert!(factory, attributes \\ []) do
    Repo.insert!(build(factory, attributes))
  end
end
