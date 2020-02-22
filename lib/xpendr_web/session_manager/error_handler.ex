defmodule XpendrWeb.SessionManager.ErrorHandler do
  import Plug.Conn

  def auth_error(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, "unauthorized")
  end
end
