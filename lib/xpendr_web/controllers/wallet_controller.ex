defmodule XpendrWeb.WalletController do
  use XpendrWeb, :controller

  import XpendrWeb.Session

  alias Xpendr.Finance
  alias Xpendr.Finance.Wallet

  def index(conn, _params) do
    user = current_user(conn)
    wallets = Finance.user_wallets(user.id)
    render(conn, "index.html", wallets: wallets)
  end

  def new(conn, _params) do
    changeset = Finance.change_wallet(%Wallet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    user = current_user(conn)

    wallet_params
    |> Map.put("user_id", user.id)
    |> Finance.create_wallet()
    |> case do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet created successfully.")
        |> redirect(to: Routes.wallet_path(conn, :show, wallet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => wallet_id}) do
    user = current_user(conn)
    wallet = Finance.get_wallet!(user.id, wallet_id)
    render(conn, "show.html", wallet: wallet)
  end

  def edit(conn, %{"id" => id}) do
    wallet = Finance.get_wallet!(id)
    changeset = Finance.change_wallet(wallet)
    render(conn, "edit.html", wallet: wallet, changeset: changeset)
  end

  def update(conn, %{"id" => id, "wallet" => wallet_params}) do
    wallet = Finance.get_wallet!(id)

    case Finance.update_wallet(wallet, wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet updated successfully.")
        |> redirect(to: Routes.wallet_path(conn, :show, wallet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", wallet: wallet, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wallet = Finance.get_wallet!(id)
    {:ok, _wallet} = Finance.delete_wallet(wallet)

    conn
    |> put_flash(:info, "Wallet deleted successfully.")
    |> redirect(to: Routes.wallet_path(conn, :index))
  end
end
