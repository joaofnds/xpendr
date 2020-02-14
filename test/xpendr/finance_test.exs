defmodule Xpendr.FinanceTest do
  use Xpendr.DataCase

  alias Xpendr.{Finance, Accounts}

  describe "wallets" do
    alias Xpendr.Finance.Wallet

    @valid_attrs %{balance: 42, description: "some description", name: "some name"}
    @update_attrs %{balance: 43, description: "some updated description", name: "some updated name"}
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
        |> Enum.into(%{ user_id: user_fixture().id })
        |> Finance.create_wallet()

      wallet
      |> Repo.preload(:user)
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
        |> Enum.into(%{ user_id: user_fixture().id })
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
end
