defmodule XpendrWeb.PageController do
  use XpendrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
