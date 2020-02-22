defmodule XpendrWeb.SessionManager.Plug.AssignUser do
  import Plug.Conn

  @behaviour Plug

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    maybe_user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, maybe_user)
  end
end
