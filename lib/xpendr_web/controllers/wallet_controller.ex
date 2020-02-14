defmodule XpendrWeb.WalletController do
  use XpendrWeb, :controller

  alias Xpendr.Finance
  alias Xpendr.Finance.Wallet

  def index(conn, _params) do
    wallets = Finance.list_wallets()
    render(conn, "index.html", wallets: wallets)
  end

  def new(conn, _params) do
    changeset = Finance.change_wallet(%Wallet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"wallet" => wallet_params}) do
    case Finance.create_wallet(wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet created successfully.")
        |> redirect(to: Routes.wallet_path(conn, :show, wallet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    wallet = Finance.get_wallet!(id)
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
