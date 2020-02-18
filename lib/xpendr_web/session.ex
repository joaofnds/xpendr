defmodule XpendrWeb.Session do
  def current_user(%Plug.Conn{assigns: %{current_user: current_user}}) do
    if current_user, do: Xpendr.Accounts.get_user!(current_user.user_id)
  end
end
