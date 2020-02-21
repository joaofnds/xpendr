defmodule XpendrWeb.SessionController do
  use XpendrWeb, :controller

  alias Xpendr.{Accounts, Accounts.User}
  alias XpendrWeb.SessionManager

  def new(conn, attrs \\ %{}) do
    changeset = Accounts.change_user(struct(User, attrs))
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    Accounts.authenticate_user_with_password(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out(SessionManager.Guardian, _opts = [])
    |> redirect(to: "/")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome Back!")
    |> Guardian.Plug.sign_in(SessionManager.Guardian, user)
    |> redirect(to: "/")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
