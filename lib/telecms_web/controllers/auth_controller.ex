defmodule TelecmsWeb.AuthController do
  use TelecmsWeb, :controller

  def index(conn, _params) do
    render(conn, "auth.html")
  end
end
