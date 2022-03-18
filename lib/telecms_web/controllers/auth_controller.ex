defmodule TelecmsWeb.AuthController do
  require Logger
  use TelecmsWeb, :controller

  # TODO move to view
  def td_client_state() do
    GenServer.call(:client, %{"@__rpc" => "get_state"})
    |> Map.take([:client_status, :auth_state])
    |> Map.to_list()
  end

  def index(conn, params) when map_size(params) == 0 do
    render(conn, "auth.html", td_client_state())
  end

  def send_code(conn, _params) do
    GenServer.cast(:client, %{"@__rpc" => "send_code"})
    redirect(conn, to: "/auth")
  end

  def check_code(conn, %{"auth_code" => code}) do
    req = %{"@__rpc" => "check_code", "value" => code}
    Logger.warn(req)
    GenServer.cast(:client, req)
    redirect(conn, to: "/auth")
  end
end
