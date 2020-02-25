defmodule XpendrWeb.SessionManager.Plug do
  alias XpendrWeb.SessionManager
  alias Xpendr.Accounts.User
  import Plug.Conn

  def halt_unauthorized(%Plug.Conn{halted: true} = conn, _), do: conn

  def halt_unauthorized(%Plug.Conn{assigns: %{authorized: false}} = conn, _opts) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(401, "unauthorized")
    |> halt()
  end

  def halt_unauthorized(%Plug.Conn{assigns: %{authorized: true}} = conn, _opts), do: conn
  def halt_unauthorized(%Plug.Conn{} = conn, _opts), do: conn

  def halt_not_found(%Plug.Conn{halted: true} = conn, _), do: conn

  def halt_not_found(%Plug.Conn{assigns: assigns} = conn, [{:key, key} | opts]) do
    if handle_action?(conn, opts) do
      if Map.get(assigns, key) do
        conn
      else
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(404, "Not Found")
        |> halt()
      end
    else
      conn
    end
  end

  defp handle_action?(_, []), do: true

  defp handle_action?(%{private: %{phoenix_action: action}}, except: except) do
    action not in except
  end

  defp handle_action?(%{private: %{phoenix_action: action}}, include: include) do
    action in include
  end

  def authorize_connection(%Plug.Conn{halted: true} = conn, _), do: conn
  def authorize_connection(%Plug.Conn{} = conn, nil), do: conn

  def authorize_connection(%Plug.Conn{} = conn, %User{} = user) do
    token = gen_token(user)

    conn
    |> assign(:current_user, user)
    |> put_req_header("authorization", "bearer: " <> token)
  end

  defp gen_token(%User{} = user) do
    {:ok, token, _} = SessionManager.Guardian.encode_and_sign(user, %{}, token_type: :access)
    token
  end
end
