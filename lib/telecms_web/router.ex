defmodule TelecmsWeb.Router do
  use TelecmsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TelecmsWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TelecmsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/auth", AuthController, :index
    get "/auth/send_code", AuthController, :send_code
    get "/auth/check_code", AuthController, :check_code

  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TelecmsWeb.Telemetry
    end
  end
end
