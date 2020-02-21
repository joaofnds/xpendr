defmodule XpendrWeb.SessionManager.Helper do
  import Plug.Conn, only: [assign: 3]

  def assign_user_to_conn(conn, _opts) do
    maybe_user = Guardian.Plug.current_resource(conn)
    assign(conn, :current_user, maybe_user)
  end
end
