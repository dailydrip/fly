# Fly
> A project from [DailyDrip](https://www.dailydrip.com).

Fly is an OTP application you can use to transform files on the fly with various
workers.

It's very much in-progress at present!  As in, it doesn't work at all like you
want yet!  Ultimately, you will be able to use it to generate URLs that specify
Just-in-Time transformations of a given file.

For now, the API will certainly change as it's *extremely early in development*.

## Usage in a Phoenix Application

There's [an example application here](http://github.com/dailydrip/fly_example).

In general, the setup is trivial.  First, add the dependency and start the `fly`
application:

```elixir
  def application do
    [
      mod: {YourAppHere, []},
      applications: [
        # ...
        :fly,
      ]
    ]
  end
  defp deps do
    [ # ...
      {:fly, path: "../fly"},
    ]
  end
```

Then you'll want to configure Fly, in `config/config.exs`.  Here's an example
configuration:

```elixir
config :fly, :workers,
  %{
    static: {Fly.Worker.StaticText, %{}},
    pngify: {Fly.Worker.Pngify, %{}},
    resize: {Fly.Worker.Resize, %{}}
  }
```

Finally, forward requests to `Fly.Plug`.  In `web/router.ex`:

```elixir
defmodule YourAppHere.Router do
  use YourAppHere.Web, :router
  # ...
  forward "/fly", Fly.Plug
  # ...
end
```

Now, `Fly` is ready to take your requests.  You can create a URL that will route
a request through `Fly.Plug`:

```html
<img src="/fly/resize?url=http://www.rd.com/wp-content/uploads/sites/2/2016/04/01-cat-wants-to-tell-you-laptop.jpg&size=400x" />
```

Now if you load the page, you'll see the image in that URL returned, resized to
400 px wide and respecting its aspect ratio, using imagemagick to do the
resizing (but this is just a function of the `resize` worker you configured
earlier!)

## Building a worker

You can look at the [Fly.Worker.Resize](lib/fly/worker/resize.ex) worker to see
an example of building a worker.  You configure them in your application
configuration.  An example is in [this project's config.exs](config/config.exs).

## Using a worker

You can run workers directly:

```elixir
Fly.run(:resize, input, %{size: "100x"})
```

## About [DailyDrip](https://www.dailydrip.com)

[![DailyDrip](https://github.com/dailydrip/fly/raw/master/assets/dailydrip.png)](https://www.dailydrip.com)

> This code is part of [Elixir Drips](https://www.dailydrip.com/topics/elixir/),
> a daily continous learning website where you can just spend 5 minutes a day to
> learn more about Elixir (or other things!)

## TODO

Here are the items I plan to add, in no particular order:

- [ ] Support workers that don't care about URLs at all - really, the workers
  should be responsible for fetching the URL, rather than the plug.
- [ ] Cache layer
  - Add an [LRU Cache](https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU)
  - This cache would be in our supervision tree, of course.
- [ ] Output file caching
  - We need to support caching output files, so that when someone requests a
    job that's already been worked, they get it from the cache rather than
    generating it via compute again.
- [ ] Input file caching
  - I'd like to add an additional caching layer for the input files.  This way,
    if we add something like an image filter generator, it only downloads the
    source file one time.
- [ ] Image filter worker
  - [example in python using imagemagick](https://github.com/acoomans/instagram-filters)
