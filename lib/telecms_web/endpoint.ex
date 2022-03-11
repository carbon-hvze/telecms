defmodule TelecmsWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :telecms

  # TODO Set :encryption_salt to encrypt session
  @session_options [
    store: :cookie,
    key: "_telecms_key",
    signing_salt: "YRY/jorI"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # TODO package with phx.digest, gzip statics
  plug Plug.Static,
    at: "/",
    from: :telecms,
    gzip: false,
    only: ~w(assets fonts images favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug TelecmsWeb.Router
end
