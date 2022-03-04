import Config

config :telecms, TelecmsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "l+lm6cbI8n7k4f5/oCmmz3SCHdYhO6axygXFl9MWIW9lKZerqmCL4y+/p9HZSNlm",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

config :telecms, TelecmsWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/telecms_web/(live|views)/.*(ex)$",
      ~r"lib/telecms_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# processes to launch in dev environment
config :telecms, :children, [TelecmsWeb.Td.Backend, TelecmsWeb.Td.Client]

# binary path relative to the root of the project
config :telecms, :binary_path, "/tdlib-json-cli/Release/bin/tdlib_json_cli"
