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
      url = conn.query_params["url"]
      file = get(url)

      options =
        conn.query_params
        |> Map.delete("url")
        |> Enum.map(fn({k, v}) -> {String.to_existing_atom(k), v} end)
        |> Map.new

      result = Fly.run(config_atom, file, options)
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
end
