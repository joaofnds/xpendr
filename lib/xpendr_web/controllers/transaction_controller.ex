defmodule XpendrWeb.TransactionController do
  use XpendrWeb, :controller

  alias Xpendr.Finance
  alias Xpendr.Finance.Transaction

  def index(conn, _params) do
    user = conn.assigns.current_user
    transactions = Finance.list_transactions(user.id)
    render(conn, "index.html", transactions: transactions)
  end

  def new(conn, _params) do
    user = conn.assigns.current_user
    wallets = Finance.user_wallets(user.id)
    changeset = Finance.change_transaction(%Transaction{})
    render(conn, "new.html", wallets: wallets, changeset: changeset)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    user = conn.assigns.current_user

    case Finance.create_transaction(user.id, transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Finance.get_transaction!(id)
    render(conn, "show.html", transaction: transaction)
  end

  def edit(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    wallets = Finance.user_wallets(user.id)
    transaction = Finance.get_transaction!(id)
    changeset = Finance.change_transaction(transaction)

    render(
      conn,
      "edit.html",
      wallets: wallets,
      transaction: transaction,
      changeset: changeset
    )
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Finance.get_transaction!(id)

    case Finance.update_transaction(transaction, transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction updated successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", transaction: transaction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Finance.get_transaction!(id)
    {:ok, transaction} = Finance.delete_transaction(transaction)

    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: Routes.wallet_path(conn, :show, transaction.wallet_id))
  end
end
