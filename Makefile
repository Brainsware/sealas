secret_config = apps/sealas_sso/config/config.secret.exs
$(secret_config):
	echo 'use Mix.Config' > $(secret_config)

mix-tools: $(secret_config)
	mix local.hex --force
	mix local.rebar --force

mix-prepare: $(secret_config)
	mix deps.get
	mix compile

mix-test: $(secret_config)
	mix test
