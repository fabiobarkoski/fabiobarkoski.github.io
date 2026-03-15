import Config

config :tailwind,
  version_check: false,
  path: Path.expand("../npm/node_modules/.bin/tailwindcss", __DIR__),
  default: [
    args: ~w(
      --input=npm/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]
