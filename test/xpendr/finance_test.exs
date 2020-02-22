defmodule Xpendr.FinanceTest do
  use Xpendr.DataCase, async: true

  alias Xpendr.{Finance, Accounts}

  describe "wallets" do
    alias Xpendr.Finance.Wallet

    @valid_attrs %{balance: 42, description: "some description", name: "some name"}
    @update_attrs %{
      balance: 43,
      description: "some updated description",
      name: "some updated name"
    }
    @invalid_attrs %{user_id: nil, balance: nil, description: nil, name: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{name: "some name", username: "some username"})
        |> Accounts.create_user()

      user
    end

    def wallet_fixture(attrs \\ %{}) do
      {:ok, wallet} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Enum.into(%{user_id: user_fixture().id})
        |> Finance.create_wallet()

      wallet
      |> Repo.preload([:user, :transactions])
    end

    test "list_wallets/0 returns all wallets" do
      wallet = wallet_fixture()
      assert Finance.list_wallets() == [wallet]
    end

    test "get_wallet!/1 returns the wallet with given id" do
      wallet = wallet_fixture()
      assert Finance.get_wallet!(wallet.id) == wallet
    end

    test "create_wallet/1 with valid data creates a wallet" do
      assert {:ok, %Wallet{} = wallet} =
               @valid_attrs
               |> Enum.into(%{user_id: user_fixture().id})
               |> Finance.create_wallet()

      assert wallet.balance == 42
      assert wallet.description == "some description"
      assert wallet.name == "some name"
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_wallet(@invalid_attrs)
    end

    test "update_wallet/2 with valid data updates the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{} = wallet} = Finance.update_wallet(wallet, @update_attrs)
      assert wallet.balance == 43
      assert wallet.description == "some updated description"
      assert wallet.name == "some updated name"
    end

    test "update_wallet/2 with invalid data returns error changeset" do
      wallet = wallet_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_wallet(wallet, @invalid_attrs)
      assert wallet == Finance.get_wallet!(wallet.id)
    end

    test "delete_wallet/1 deletes the wallet" do
      wallet = wallet_fixture()
      assert {:ok, %Wallet{}} = Finance.delete_wallet(wallet)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_wallet!(wallet.id) end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = wallet_fixture()
      assert %Ecto.Changeset{} = Finance.change_wallet(wallet)
    end
  end

  describe "transactions" do
    alias Xpendr.Finance.Transaction

    @valid_attrs %{amount: 42, description: "some description", type: "income"}
    @update_attrs %{
      amount: 43,
      description: "some updated description",
      type: "expense"
    }
    @invalid_attrs %{amount: nil, description: nil, type: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.merge(%{wallet_id: wallet_fixture().id})
        |> Finance.create_transaction()

      transaction
      |> Repo.preload(wallet: :user)
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Finance.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Finance.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} =
               @valid_attrs
               |> Map.merge(%{wallet_id: wallet_fixture().id})
               |> Finance.create_transaction()

      assert transaction.amount == 42
      assert transaction.description == "some description"
      assert transaction.type == "income"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()

      assert {:ok, %Transaction{} = transaction} =
               Finance.update_transaction(transaction, @update_attrs)

      assert transaction.amount == 43
      assert transaction.description == "some updated description"
      assert transaction.type == "expense"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_transaction(transaction, @invalid_attrs)
      assert transaction == Finance.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Finance.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Finance.change_transaction(transaction)
    end
  end
end
