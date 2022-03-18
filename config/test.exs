import Config

config :telecms, TelecmsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Wq5HBszA94qNIqRtsIsjRxnFPIf2ZWLxRGG6WPdIJyubCz/7nvPIM3o2qKTAULIK",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# start test version of tdlib transport in test env
config :telecms, :children, [TestBackend]

config :telecms, :binary_path, "/tdlib-json-cli/Release/bin/tdlib_json_cli"

config :telecms, :tdlib_log_level, "1"
