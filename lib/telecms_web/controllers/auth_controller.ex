defmodule TelecmsWeb.AuthController do
  require Logger
  use TelecmsWeb, :controller

  def td_client_state() do
    GenServer.call(:client, %{"@__rpc" => "get_state"})
    |> Map.take([:client_status, :auth_state])
    |> Map.to_list()
  end

  def index(conn, _params = %{}) do
    render(conn, "auth.html", td_client_state())
  end

  def index(conn, %{send_code: _code_transport}) do
    render(conn, "auth.html", [{:state, :code_sent}] ++ td_client_state())
  end
end
