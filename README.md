# MaxwellTimber

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