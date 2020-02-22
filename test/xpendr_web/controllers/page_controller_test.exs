defmodule XpendrWeb.PageControllerTest do
  use XpendrWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Xpendr"
  end
end
