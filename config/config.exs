# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chat_backend,
  ecto_repos: [ChatBackend.Repo]

# Configures the endpoint
config :chat_backend, ChatBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2r3JVrusEEQhBk9g68p4d58E3Axk4sPpa9Kmklc6X5+4gwpYY2TYFNW0CGNO6QPT",
  render_errors: [view: ChatBackendWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ChatBackend.PubSub,
  live_view: [signing_salt: "nW3j1IG6"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# config :guardian, Guardian,
#   issuer: "chatbackend",
#   secret_key: "km2v4XmLoxbaxNTFpGyKIzEvJzxJT3ge6M/qR4q3cjVP5rKtXe2k4qfKjbT97Ck7",
#   serializer: ChatBackend.GuardianSerializer

config :chat_backend, ChatBackend.Guardian,
  issuer: "tutorial",
  secret_key: "BY8grm00++tVtByLhHG15he/3GlUG0rOSLmP2/2cbIRwdR4xJk1RHvqGHPFuNcF8",
  ttl: {3, :days}

config :chat_backend, ChatBackendWeb.AuthAccessPipeline,
  module: ChatBackend.Guardian,
  error_handler: ChatBackendWeb.AuthErrorHandler
