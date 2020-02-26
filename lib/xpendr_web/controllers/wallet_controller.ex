defmodule XpendrWeb.WalletController do
  use XpendrWeb, :controller

  alias Xpendr.Finance
  alias Xpendr.Finance.Wallet

  plug :load_and_authorize_resource, model: Wallet, preload: Finance.wallet_preloads()
  plug :halt_not_found, key: :wallet, except: [:index, :new, :create]
  plug :halt_unauthorized

  def index(conn, _params) do
    user = conn.assigns.current_user
    wallets = Finance.user_wallets(user.id)
    render(conn, "index.html", wallets: wallets)
  end

  def new(conn, _params) do
    changeset = Finance.change_wallet(%Wallet{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(%{assigns: %{current_user: user}} = conn, %{"wallet" => wallet_params}) do
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

  def show(%Plug.Conn{assigns: %{wallet: wallet}} = conn, _) do
    render(conn, "show.html", wallet: wallet)
  end

  def edit(%Plug.Conn{assigns: %{wallet: wallet}} = conn, _) do
    changeset = Finance.change_wallet(wallet)
    render(conn, "edit.html", wallet: wallet, changeset: changeset)
  end

  def update(%Plug.Conn{assigns: %{wallet: wallet}} = conn, %{
        "wallet" => wallet_params
      }) do
    case Finance.update_wallet(wallet, wallet_params) do
      {:ok, wallet} ->
        conn
        |> put_flash(:info, "Wallet updated successfully.")
        |> redirect(to: Routes.wallet_path(conn, :show, wallet))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", wallet: wallet, changeset: changeset)
    end
  end

  def delete(%Plug.Conn{assigns: %{wallet: wallet}} = conn, _) do
    {:ok, _wallet} = Finance.delete_wallet(wallet)

    conn
    |> put_flash(:info, "Wallet deleted successfully.")
    |> redirect(to: Routes.wallet_path(conn, :index))
  end
end
