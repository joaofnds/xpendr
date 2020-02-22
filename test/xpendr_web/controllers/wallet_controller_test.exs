defmodule XpendrWeb.WalletControllerTest do
  use XpendrWeb.ConnCase, async: true

  alias Xpendr.Finance

  @create_attrs %{balance: 42, description: "some description", name: "some name"}
  @update_attrs %{balance: 43, description: "some updated description", name: "some updated name"}
  @invalid_attrs %{balance: nil, description: nil, name: nil}

  def fixture(:user) do
    insert(:user)
  end

  def fixture(:wallet) do
    user = fixture(:user)

    {:ok, wallet} =
      @create_attrs
      |> Map.merge(%{user_id: user.id})
      |> Finance.create_wallet()

    wallet
  end

  describe "index" do
    test "lists all wallets", %{conn: conn} do
      conn = get(conn, Routes.wallet_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Wallets"
    end
  end

  describe "new wallet" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.wallet_path(conn, :new))
      assert html_response(conn, 200) =~ "New Wallet"
    end
  end

  describe "create wallet" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.wallet_path(conn, :create),
          wallet: Map.merge(@create_attrs, %{user_id: fixture(:user).id})
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.wallet_path(conn, :show, id)

      conn = get(conn, Routes.wallet_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Wallet"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.wallet_path(conn, :create), wallet: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Wallet"
    end
  end

  describe "edit wallet" do
    setup [:create_wallet]

    test "renders form for editing chosen wallet", %{conn: conn, wallet: wallet} do
      conn = get(conn, Routes.wallet_path(conn, :edit, wallet))
      assert html_response(conn, 200) =~ "Edit Wallet"
    end
  end

  describe "update wallet" do
    setup [:create_wallet]

    test "redirects when data is valid", %{conn: conn, wallet: wallet} do
      conn = put(conn, Routes.wallet_path(conn, :update, wallet), wallet: @update_attrs)
      assert redirected_to(conn) == Routes.wallet_path(conn, :show, wallet)

      conn = get(conn, Routes.wallet_path(conn, :show, wallet))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, wallet: wallet} do
      conn = put(conn, Routes.wallet_path(conn, :update, wallet), wallet: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Wallet"
    end
  end

  describe "delete wallet" do
    setup [:create_wallet]

    test "deletes chosen wallet", %{conn: conn, wallet: wallet} do
      conn = delete(conn, Routes.wallet_path(conn, :delete, wallet))
      assert redirected_to(conn) == Routes.wallet_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.wallet_path(conn, :show, wallet))
      end
    end
  end

  defp create_wallet(_) do
    wallet = fixture(:wallet)
    {:ok, wallet: wallet}
  end
end
