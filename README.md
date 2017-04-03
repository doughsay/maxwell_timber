# Maxwell Timber Middleware

[![Build Status](https://travis-ci.org/doughsay/maxwell_timber.svg?branch=master)](https://travis-ci.org/doughsay/maxwell_timber)
[![Code Coverage](https://img.shields.io/codecov/c/github/doughsay/maxwell_timber.svg)](https://codecov.io/gh/doughsay/maxwell_timber)
[![Hex.pm](https://img.shields.io/hexpm/v/maxwell_timber.svg)](http://hex.pm/packages/maxwell_timber)
[![Deps Status](https://beta.hexfaktor.org/badge/all/github/doughsay/maxwell_timber.svg)](https://beta.hexfaktor.org/github/doughsay/maxwell_timber)

Maxwell middleware for logging outgoing requests to Timer.io.

Using this middleware will automatically log all outgoing requests made with
maxwell to Timber.io using the correct Timber Events.

## Installation

Add `maxwell_timber` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:maxwell_timber, "~> 0.1.0"}]
end
```


## Usage

```elixir
defmodule MyClient do
  use Maxwell.Builder, ~w(get)a

  middleware MaxwellTimber.Middleware

  def my_request_with_timber_logging(path) do
    path
    |> new()
    |> get()
  end
end
```


## Configuration

You can pass in an optional `service_name` to this middleware to tag all
outgoing http requests with the given name. This will be searchable in
Timber.io's dashboard.

```elixir
middleware MaxwellTimber.Middleware, [service_name: "my_service"]
```
