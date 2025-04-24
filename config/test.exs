import Config
config :contactly, token_signing_secret: "7EFQSBYvlfEv4Y/vqbm1whmNxBqrlI2h"
config :bcrypt_elixir, log_rounds: 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :contactly, Contactly.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "contactly_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :contactly, ContactlyWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "l33knisL4kqvlw5QwRXXdmjMSnhaL9WPMuWmR44I4BJ+Iz0N1hdhv4HWq4SNLlMn",
  server: false

# In test we don't send emails
config :contactly, Contactly.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
