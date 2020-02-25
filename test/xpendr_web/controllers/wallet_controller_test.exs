defmodule XpendrWeb.WalletControllerTest do
  use XpendrWeb.ConnCase, async: true

  @create_attrs %{balance: 42, description: "some description", name: "some name"}
  @update_attrs %{balance: 43, description: "some updated description", name: "some updated name"}
  @invalid_attrs %{balance: nil, description: nil, name: nil}

  describe "index" do
    @tag :as_inserted_user
    test "lists all wallets", %{conn: conn} do
      conn = get(conn, Routes.wallet_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Wallets"
    end
  end

  @tag :as_inserted_user
  describe "new wallet" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.wallet_path(conn, :new))
      assert html_response(conn, 200) =~ "New Wallet"
    end
  end

  describe "create wallet" do
    @tag :as_inserted_user
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.wallet_path(conn, :create),
          wallet: Map.merge(@create_attrs, %{user_id: build(:user).id})
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.wallet_path(conn, :show, id)

      conn = get(conn, Routes.wallet_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Wallet"
    end

    @tag :as_inserted_user
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.wallet_path(conn, :create), wallet: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Wallet"
    end
  end

  describe "edit wallet" do
    setup [:create_wallet]

    @tag :as_inserted_user
    test "renders form for editing chosen wallet", %{conn: conn, wallet: wallet} do
      conn = get(conn, Routes.wallet_path(conn, :edit, wallet))
      assert html_response(conn, 200) =~ "Edit Wallet"
    end
  end

  describe "update wallet" do
    setup [:create_wallet]

    @tag :as_inserted_user
    test "redirects when data is valid", %{conn: conn, wallet: wallet} do
      conn = put(conn, Routes.wallet_path(conn, :update, wallet), wallet: @update_attrs)
      assert redirected_to(conn) == Routes.wallet_path(conn, :show, wallet)

      conn = get(conn, Routes.wallet_path(conn, :show, wallet))
      assert html_response(conn, 200) =~ "some updated description"
    end

    @tag :as_inserted_user
    test "renders errors when data is invalid", %{conn: conn, wallet: wallet} do
      conn = put(conn, Routes.wallet_path(conn, :update, wallet), wallet: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Wallet"
    end
  end

  @tag :as_inserted_user
  describe "delete wallet" do
    setup [:create_wallet]

    test "deletes chosen wallet", %{conn: conn, wallet: wallet} do
      conn = delete(conn, Routes.wallet_path(conn, :delete, wallet))
      assert redirected_to(conn) == Routes.wallet_path(conn, :index)

      assert nil == Xpendr.Repo.get(Xpendr.Finance.Wallet, wallet.id)
      conn = get(conn, Routes.wallet_path(conn, :show, wallet))
      assert response(conn, 404) =~ ""
    end
  end

  defp create_wallet(%{user: user}) do
    wallet = insert(:wallet, user: user)
    {:ok, wallet: wallet}
  end
end
