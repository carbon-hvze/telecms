defmodule TelecmsWeb.PageController do
  use TelecmsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
