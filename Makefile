mix-tools:
	mix local.hex --force
	mix local.rebar --force

mix-prepare:
	mix deps.get
	mix compile

secret_config = apps/sealas_sso/config/config.secret.exs
$(secret_config):
	echo 'use Mix.Config' > $(secret_config)

mix-test: $(secret_config)
	mix test
