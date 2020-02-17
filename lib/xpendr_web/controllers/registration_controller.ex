defmodule XpendrWeb.RegistrationController do
  use XpendrWeb, :controller
  alias Xpendr.{Accounts, Repo}

  def new(conn, _params) do
    changeset = Pow.Plug.change_user(conn)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => params}) do
    case Accounts.create_user_with_credential(Map.put(params, "conn", conn)) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
