defmodule Fly.PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test
  @root_dir File.cwd!
  @test_dir Path.join(@root_dir, "test")
  @fixtures_dir Path.join(@test_dir, "fixtures")

  @opts Fly.Plug.init([])
  @fly_jpg_url "https://upload.wikimedia.org/wikipedia/en/a/aa/Fly_poster.jpg"

  test "gets static text" do
    # Create a test connection
    conn =
      :get
        |> conn("/static?url=#{@fly_jpg_url}")
        |> Fly.Plug.call(@opts)

    # Assert the response and status
    assert conn.status == 200
    assert conn.resp_body == "giggity"
  end

  test "handles pngify" do
    # Create a test connection
    conn =
      :get
        |> conn("/pngify?url=#{@fly_jpg_url}")
        |> Fly.Plug.call(@opts)

    # Assert the response and status
    assert conn.status == 200
    assert conn.resp_body == read_fixture("fly.png")
  end

  test "handles resize" do
    # Create a test connection
    conn =
      :get
        |> conn("/resize?url=#{@fly_jpg_url}&size=100x")
        |> Fly.Plug.call(@opts)

    # Assert the response and status
    assert conn.status == 200
    assert conn.resp_body == read_fixture("fly_resize_100x.jpg")
  end

  defp read_fixture(filename) do
    @fixtures_dir
      |> Path.join(filename)
      |> File.read!
  end
end
