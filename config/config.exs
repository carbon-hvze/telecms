import Config

config :telecms, TelecmsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TelecmsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Telecms.PubSub,
  live_view: [signing_salt: "7nmWKHK1"]

config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

config :telecms, :database_directory, "/tmp/td_data"

import_config "#{config_env()}.exs"
import_config "#{config_env()}.secret.exs"
