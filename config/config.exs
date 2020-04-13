# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :homecooked,
  ecto_repos: [Homecooked.Repo]

# Configures the endpoint
config :homecooked, HomecookedWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yhtVa96T745uBxLFbzx58fi0l34gZ4oIQkpefHzkqRypuXbxleIwTvzvYRyg6UpI",
  render_errors: [view: HomecookedWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Homecooked.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email"]},
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
  redirect_uri: System.get_env("GITHUB_CB_URL", "https://localhost:4001/auth/github/callback")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_CB_URL", "https://localhost:4001/auth/google/callback")

config :homecooked, Homecooked.Guardian,
  issuer: "homecooked",
  secret_key:
    System.get_env(
      "GUARDIAN_KEY",
      "iexhB8tix+27rPuqzt9ZUUqTf2cSEpS0dahoc4vLBPFsrqiucA02dftBamuIuGMR"
    )

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
