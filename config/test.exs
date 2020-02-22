use Mix.Config

# Configure your database
config :xpendr, Xpendr.Repo,
  username: "postgres",
  password: "postgres",
  database: "xpendr_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :xpendr, XpendrWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Lower cost of password encryption FOR TESTS ONLY.
config :argon2_elixir, t_cost: 1, m_cost: 8
