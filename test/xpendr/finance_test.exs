defmodule Xpendr.FinanceTest do
  use Xpendr.DataCase, async: true

  alias Xpendr.Finance

  describe "wallets" do
    alias Xpendr.Finance.Wallet

    @valid_attrs %{balance: 42, description: "some description", name: "some name"}
    @update_attrs %{
      balance: 43,
      description: "some updated description",
      name: "some updated name"
    }
    @invalid_attrs %{user_id: nil, balance: nil, description: nil, name: nil}

    setup [:insert_user]

    test "get_user_wallet!/2 returns the wallet with given id", %{user: user} do
      wallet =
        insert(:wallet, user: user)
        |> Repo.preload([:user, :transactions])

      assert Finance.get_user_wallet!(user, wallet.id) == wallet
    end

    setup [:insert_user]

    test "create_wallet/1 with valid data creates a wallet", %{user: user} do
      assert {:ok, %Wallet{} = wallet} =
               @valid_attrs
               |> Enum.into(%{user_id: user.id})
               |> Finance.create_wallet()

      assert wallet.balance == 42
      assert wallet.description == "some description"
      assert wallet.name == "some name"
    end

    test "create_wallet/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_wallet(@invalid_attrs)
    end

    setup [:insert_user]

    test "update_wallet/2 with valid data updates the wallet", %{user: user} do
      wallet = insert(:wallet, user: user)
      assert {:ok, %Wallet{} = wallet} = Finance.update_wallet(wallet, @update_attrs)
      assert wallet.balance == 43
      assert wallet.description == "some updated description"
      assert wallet.name == "some updated name"
    end

    setup [:insert_user]

    test "update_wallet/2 with invalid data returns error changeset", %{user: user} do
      wallet =
        insert(:wallet, user: user)
        |> Repo.preload([:transactions])

      assert {:error, %Ecto.Changeset{}} = Finance.update_wallet(wallet, @invalid_attrs)

      assert wallet == Finance.get_user_wallet!(user, wallet.id)
    end

    setup [:insert_user]

    test "delete_wallet/1 deletes the wallet", %{user: user} do
      wallet = insert(:wallet, user: user)
      assert {:ok, %Wallet{}} = Finance.delete_wallet(wallet)

      assert_raise Ecto.NoResultsError, fn ->
        Finance.get_user_wallet!(user, wallet.id)
      end
    end

    test "change_wallet/1 returns a wallet changeset" do
      wallet = build(:wallet)
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

    setup [:insert_user, :insert_wallet]

    test "get_transaction!/1 returns the transaction with given id", %{wallet: wallet} do
      transaction = insert(:transaction, wallet: wallet)
      assert Finance.get_transaction!(transaction.id) == transaction
    end

    setup [:insert_user, :insert_wallet]

    test "create_transaction/1 with valid data creates a transaction", %{wallet: wallet} do
      assert {:ok, %Transaction{} = transaction} =
               @valid_attrs
               |> Map.merge(%{wallet_id: wallet.id})
               |> Finance.create_transaction()

      assert transaction.amount == 42
      assert transaction.description == "some description"
      assert transaction.type == "income"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_transaction(@invalid_attrs)
    end

    setup [:insert_user, :insert_wallet]

    test "update_transaction/2 with valid data updates the transaction", %{wallet: wallet} do
      transaction = insert(:transaction, wallet: wallet)

      assert {:ok, %Transaction{} = transaction} =
               Finance.update_transaction(transaction, @update_attrs)

      assert transaction.amount == 43
      assert transaction.description == "some updated description"
      assert transaction.type == "expense"
    end

    setup [:insert_user, :insert_wallet]

    test "update_transaction/2 with invalid data returns error changeset", %{wallet: wallet} do
      transaction = insert(:transaction, wallet: wallet)
      assert {:error, %Ecto.Changeset{}} = Finance.update_transaction(transaction, @invalid_attrs)
      assert transaction == Finance.get_transaction!(transaction.id)
    end

    setup [:insert_user, :insert_wallet]

    test "delete_transaction/1 deletes the transaction", %{wallet: wallet} do
      transaction = insert(:transaction, wallet: wallet)
      assert {:ok, %Transaction{}} = Finance.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = build(:transaction)
      assert %Ecto.Changeset{} = Finance.change_transaction(transaction)
    end
  end

  def insert_user(_) do
    user = insert(:user)
    {:ok, user: user}
  end

  def insert_wallet(%{user: user}) do
    wallet = insert(:wallet, user: user)
    {:ok, wallet: wallet}
  end
end
