defmodule XpendrWeb.SessionManager.Plug do
  alias XpendrWeb.SessionManager
  alias Xpendr.Accounts.User
  import Plug.Conn

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
