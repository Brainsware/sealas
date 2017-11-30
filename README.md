# Sealas - Zero Knowledge Online Accounting Software For Freelancers

Sealas is Open Source. Open Source in all matters technical: the source code is available on Github, and everybody's welcome to support us with pull requests.

... and Open Source in spirit: we write about the whole development of Sealas and the hows and whys behind our technical, design and business decisions.

Check out the [website and blog repository](https://github.com/Brainsware/sealas-site), and follow our development of Sealas here: [https://sealas.at/blog](https://sealas.at/blog)

## Build Status

We build our software on three different CI systems, and then compare the result:

Travis CI: [![Travis CI Build Status](https://travis-ci.org/Brainsware/sealas.svg?branch=master)](https://travis-ci.org/Brainsware/sealas)
CircleCI: [![CircleCI Build Status](https://circleci.com/gh/Brainsware/sealas.svg?style=svg)](https://circleci.com/gh/Brainsware/sealas)
AppVeyor: [![AppVyor Build status](https://ci.appveyor.com/api/projects/status/va3txhnkajgnq82b/branch/master?svg=true)](https://ci.appveyor.com/project/Brainsware/sealas/branch/master)

### Elixir status

[![Deps Status](https://beta.hexfaktor.org/badge/all/github/Brainsware/sealas.svg)](https://beta.hexfaktor.org/github/Brainsware/sealas)

## Development

To start dev server:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).
