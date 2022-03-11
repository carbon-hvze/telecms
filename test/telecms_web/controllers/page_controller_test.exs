defmodule TelecmsWeb.PageControllerTest do
  use TelecmsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "telecms alpha build"
  end
end
