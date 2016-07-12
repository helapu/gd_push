# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :gd_push,
  ecto_repos: [GdPush.Repo]

# Configures the endpoint
config :gd_push, GdPush.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "+o4Zp3+aYlAoppSvXIHJXpjIEokoC7WYEUlplh90SNW8D2ufk3pOK7W/bUxbSmaJ",
  render_errors: [view: GdPush.ErrorView, accepts: ~w(html json)],
  pubsub: [name: GdPush.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]


# apns
config :apns,
  # Here goes "global" config applied as default to all pools started if not overwritten by pool-specific value
  callback_module:    APNS.Callback,
  timeout:            30,
  feedback_interval:  1200,
  support_old_ios:    false,
  expiry:    60,
  # Here are pools configs. Any value from "global" config can be overwritten in any single pool config
  pools: [
    # app1_dev_pool is the pool_name
    app1_dev_pool: [
      env: :dev,
      pool_size: 1,
      pool_max_overflow: 0,
      # and this is overwritten config key
      certfile: "/Users/Helapu/Github/gd_push/priv/certificate/cert_pri_dev.pem"
    ],
    app1_prod_pool: [
      env: :prod,
      certfile: "/Users/Helapu/Github/gd_push/priv/certificate/cert_pri_dev.pem",
      pool_size: 100,
      pool_max_overflow: 0
    ],
  ]

# ElasticSearch
config :tirexs, :uri, "http://127.0.0.1:9200"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
