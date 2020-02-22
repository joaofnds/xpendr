defmodule XpendrWeb.TransactionControllerTest do
  use XpendrWeb.ConnCase, async: true

  alias Xpendr.Finance

  @create_attrs %{amount: 42, description: "some description", type: "income"}
  @update_attrs %{amount: 43, description: "some updated description", type: "expense"}
  @invalid_attrs %{amount: nil, description: nil, type: nil}

  @tag :as_inserted_user
  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Transactions"
    end
  end

  @tag :as_inserted_user
  describe "new transaction" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :new))
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  @tag :as_inserted_user
  describe "create transaction" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.transaction_path(conn, :create),
          transaction:
            Map.merge(
              @create_attrs,
              %{wallet_id: insert(:wallet).id}
            )
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.transaction_path(conn, :show, id)

      conn = get(conn, Routes.transaction_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Transaction"
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transaction_path(conn, :create), transaction: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Transaction"
    end
  end

  @tag :as_inserted_user
  describe "edit transaction" do
    setup [:create_transaction]

    test "renders form for editing chosen transaction", %{conn: conn, transaction: transaction} do
      conn = get(conn, Routes.transaction_path(conn, :edit, transaction))
      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  describe "update transaction" do
    setup :create_transaction

    @tag :as_inserted_user
    test "redirects when data is valid", %{conn: conn, transaction: transaction} do
      conn =
        put(conn, Routes.transaction_path(conn, :update, transaction), transaction: @update_attrs)

      assert redirected_to(conn) == Routes.transaction_path(conn, :show, transaction)

      conn = get(conn, Routes.transaction_path(conn, :show, transaction))
      assert html_response(conn, 200) =~ "some updated description"
    end

    setup :create_transaction
    @tag :as_inserted_user
    test "renders errors when data is invalid", %{conn: conn, transaction: transaction} do
      conn =
        conn
        |> Plug.Conn.assign(:wallets, [transaction.wallet])
        |> put(Routes.transaction_path(conn, :update, transaction), transaction: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Transaction"
    end
  end

  @tag :as_inserted_user
  describe "delete transaction" do
    setup [:create_transaction]

    test "deletes chosen transaction", %{conn: conn, transaction: transaction} do
      conn = delete(conn, Routes.transaction_path(conn, :delete, transaction))
      assert redirected_to(conn) == Routes.wallet_path(conn, :show, transaction.wallet_id)

      assert_error_sent 404, fn ->
        get(conn, Routes.transaction_path(conn, :show, transaction))
      end
    end
  end

  defp create_transaction(%{user: user}) do
    wallet = insert(:wallet, user: user)
    transaction = insert(:transaction, wallet: wallet)
    {:ok, transaction: transaction, wallet: wallet}
  end
end
