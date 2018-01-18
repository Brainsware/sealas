# Sealas - Zero Knowledge Online Accounting Software For Freelancers

Follow the journey of our development of a secure client-side encrypted accounting software.

Learn with us the ins and outs of working on a project with the focus on security and usability.
We write about the challenges, hows and whys behind our technical, design and business decisions.

Check out the blog here: [https://sealas.at/blog](https://sealas.at/blog)

## Build Status

We build our software on three different CI systems, and then compare the result:

Travis CI: [![Travis CI Build Status](https://travis-ci.org/Brainsware/sealas.svg?branch=master)](https://travis-ci.org/Brainsware/sealas)
CircleCI: [![CircleCI Build Status](https://circleci.com/gh/Brainsware/sealas.svg?style=svg)](https://circleci.com/gh/Brainsware/sealas)
AppVeyor: [![AppVyor Build status](https://ci.appveyor.com/api/projects/status/va3txhnkajgnq82b/branch/master?svg=true)](https://ci.appveyor.com/project/Brainsware/sealas/branch/master)

### Elixir status

[![Deps Status](https://beta.hexfaktor.org/badge/all/github/Brainsware/sealas.svg)](https://beta.hexfaktor.org/github/Brainsware/sealas)
[![Inline docs](https://inch-ci.org/github/Brainsware/sealas.svg?branch=master&style=flat)](https://inch-ci.org/github/Brainsware/sealas)

## Structure

Sealas is built as an umbrella app (explained in more detail here: [https://sealas.at/blog/2017-08/setting-up-a-phoenix-umbrella-app/](https://sealas.at/blog/2017-08/setting-up-a-phoenix-umbrella-app/))

### `apps/sealas_sso`

The SSO or authentication app handles all interaction with the user database. Registration, authorization, registration and access recovery are done here.

### `apps/sealas_api`

All interaction with the permanent datastore goes through this part, as well as some access to authentication mechanisms.

### `apps/sealas_web`

The main part of the the actual client and the one that relies the least on the backend, as it's mostly static content. All of the javascript base goes here, along with the generators, along with the generators and CSS files.

## Development

To start dev server:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).
