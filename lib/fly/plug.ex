defmodule Fly.Plug do
  @behaviour Plug
  import Plug.Conn
  alias Plug.Conn
  require Logger

  def init([]), do: []

  def call(%Conn{path_info: [config_atom_string]} = conn, []) do
    try do
      config_atom = String.to_existing_atom(config_atom_string)
      conn = fetch_query_params(conn)
      cache_key = {config_atom, conn.query_params}
      result =
        case LruCache.get(:fly_cache, cache_key) do
          nil ->
            url = conn.query_params["url"]
            input =
              case url do
                nil -> ""
                _ -> get_cached(url)
              end

            options =
              conn.query_params
              |> Map.delete("url")
              |> Enum.map(fn({k, v}) -> {String.to_existing_atom(k), v} end)
              |> Map.new

            Fly.run_cached(cache_key, config_atom, input, options)
          v -> v
        end

      conn
        |> resp(200, result)
    rescue
      e in ArgumentError ->
        Logger.error (inspect e)
        Logger.error "Zomg no good: #{inspect config_atom_string}"
        Logger.error "here's conn: #{inspect conn}"
        conn
    end
  end
  def call(conn, []), do: conn

  defp get(url) do
    %{body: body} = Fly.Http.get(url, opts: [recv_timeout: 150_000])
    body
  end

  defp get_cached(url) do
    case LruCache.get(:fly_cache, url) do
      nil ->
        get(url)
      v -> v
    end
  end
end
