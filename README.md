# Fly
> A project from [DailyDrip](https://www.dailydrip.com).

Fly is an OTP application you can use to transform files on the fly with various
workers.

It's very much in-progress at present!  As in, it doesn't work at all like you
want yet!  Ultimately, you will be able to use it to generate URLs that specify
Just-in-Time transformations of a given file.

For now, the API will certainly change as it's *extremely early in development*.

## Installation

The package can be installed by doing the following:

  1. Add `fly` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:fly, "~> 0.1.0"}]
    end
    ```

  2. Ensure `fly` is started before your application:

    ```elixir
    def application do
      [applications: [:fly]]
    end
    ```

## Configuration

Here's an example configuration - you'll need **something** configured for the
app, so use this until you know more :)

```elixir
config :fly, :workers,
  %{
    static: {Fly.Worker.StaticText, %{}},
    pngify: {Fly.Worker.Pngify, %{}},
    resize: {Fly.Worker.Resize, %{}}
  }
```

## Building a worker

You can look at the [Fly.Worker.Resize](lib/fly/worker/resize.ex) worker to see
an example of building a worker.  You configure them in your application
configuration.  An example is in [this project's config.exs](config/config.exs).

## Using a worker

For now, you can just run workers directly:

```elixir
Fly.run(:resize, input, %{size: "100x"})
```

### About [DailyDrip](https://www.dailydrip.com)

[![DailyDrip](http://github.com/dailydrip/fly/raw/master/assets/dailydrip.png)](https://www.dailydrip.com)

> This code is part of [Elixir Drips](https://www.dailydrip.com/topics/elixir/),
> a daily continous learning website where you can just spend 5 minutes a day to
> learn more about Elixir (or other things!)
