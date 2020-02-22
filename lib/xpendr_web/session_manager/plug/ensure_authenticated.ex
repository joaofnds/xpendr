defmodule XpendrWeb.SessionManager.Plug.EnsureAuthenticated do
  import Plug.Conn
  import XpendrWeb.SessionManager.ErrorHandler

  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> auth_error()
    |> halt()
  end

  def call(conn, _), do: conn
end
