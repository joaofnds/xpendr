defmodule XpendrWeb.Absinthe do
  def put_absinthe_context(conn, _) do
    current_user = conn.assigns[:current_user]
    Absinthe.Plug.put_options(conn, context: %{current_user: current_user})
  end
end
