defmodule XpendrWeb.TransactionController do
  use XpendrWeb, :controller

  alias Xpendr.Finance
  alias Xpendr.Finance.Transaction

  plug :load_and_authorize_resource, model: Transaction, preload: [wallet: :user]
    user = conn.assigns.current_user
  def index(%{assigns: %{current_user: user}} = conn, _params) do
    transactions = Finance.list_transactions(user.id)
    render(conn, "index.html", transactions: transactions)
  end

  def new(%{assigns: %{current_user: user}} = conn, _params) do
    wallets = Finance.user_wallets(user.id)
    changeset = Finance.change_transaction(%Transaction{})
    render(conn, "new.html", wallets: wallets, changeset: changeset)
  end

  def create(%{assigns: %{current_user: user}} = conn, %{"transaction" => transaction_params}) do
    case Finance.create_transaction(transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

      {:error, changeset} ->
        wallets = Finance.user_wallets(user.id)
        render(conn, "new.html", changeset: changeset, wallets: wallets)
    end
  end

  def show(%{assigns: %{transaction: transaction}} = conn, _params) do
    render(conn, "show.html", transaction: transaction)
  end

  def edit(%{assigns: %{current_user: user, transaction: transaction}} = conn, _params) do
    wallets = Finance.user_wallets(user.id)
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

  def delete(%{assigns: %{transaction: transaction}} = conn, _params) do
    {:ok, transaction} = Finance.delete_transaction(transaction)

    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: Routes.wallet_path(conn, :show, transaction.wallet_id))
  end
end
