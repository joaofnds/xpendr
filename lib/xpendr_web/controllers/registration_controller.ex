defmodule XpendrWeb.RegistrationController do
  use XpendrWeb, :controller
  alias Xpendr.Accounts
  import Pow.Phoenix.RegistrationController, except: [action: 2]

  def new(conn, _params) do
    changeset = Pow.Plug.change_user(conn)

    render(conn, "new.html", changeset: changeset, action: "/signup")
  end

  def create(conn, %{"user" => params}) do
    {:ok, user} = Accounts.create_user(params)
    {:ok, credential, conn} = Pow.Plug.create_user(
      conn,
      Map.put(params, "user_id", user.id)
    )

    conn
    |> put_flash(:info, "Welcome!")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
