defmodule Fly.Http do
  use Tesla
  adapter Tesla.Adapter.Hackney
end
