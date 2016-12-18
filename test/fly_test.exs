defmodule FlyTest do
  use ExUnit.Case
  doctest Fly
  @root_dir File.cwd!
  @test_dir Path.join(@root_dir, "test")
  @fixtures_dir Path.join(@test_dir, "fixtures")

  test "basic worker that ignores input file and returns static text" do
    assert "giggity" = Fly.run(:static, "")
  end

  test "worker to convert to png" do
    input =
      @fixtures_dir
        |> Path.join("fly.jpg")
        |> File.read!

    expected =
      @fixtures_dir
        |> Path.join("fly.png")
        |> File.read!

    assert expected == Fly.run(:pngify, input)
  end

  test "worker to resize" do
    input =
      @fixtures_dir
        |> Path.join("fly.jpg")
        |> File.read!

    expected =
      @fixtures_dir
        |> Path.join("fly_resize_100x.jpg")
        |> File.read!

    assert expected == Fly.run(:resize, input, %{size: "100x"})
  end

  test "worker is invoked if there is no value in the cache corresponding to the request" do
    request_key = "some key"
    LruCache.delete(:fly_cache, request_key)
    setup_dbg()
    Dbg.call(&Fly.Worker.StaticText.call/2)
    Fly.run_cached(request_key, :static, "")
    teardown_dbg()
    assert dbg_capture() =~ ~r(calls Fly.Worker.StaticText.call/2)
  end

  test "worker is not invoked if there is a value in the cache corresponding to the request" do
    request_key = "some key"
    LruCache.put(:fly_cache, request_key, "boo")
    setup_dbg()
    Dbg.call(&Fly.Worker.StaticText.call/2)
    result = Fly.run_cached(request_key, :static, "")
    teardown_dbg()
    refute dbg_capture() =~ ~r(calls Fly.Worker.StaticText.call/2)
    assert result == "boo"
  end

  test "worker sets the cache value if there is no value in the cache corresponding to the request" do
    request_key = "some key"
    LruCache.delete(:fly_cache, request_key)
    Fly.run_cached(request_key, :static, "")
    assert LruCache.get(:fly_cache, request_key) == Fly.run(:static, "")
  end

  defp setup_dbg() do
    File.rm!(log_file())
    Application.put_env(:dbg, :device, {:file, log_file()})
    Dbg.reset()
    Dbg.trace(self(), :call)
  end

  defp teardown_dbg() do
    Application.delete_env(:dbg, :device)
    Dbg.reset()
  end

  defp dbg_capture() do
    ExUnit.CaptureIO.capture_io(fn ->
      Dbg.inspect_file(log_file)
    end)
  end

  defp log_file() do
    Path.join(System.tmp_dir!(), "dbg.log")
  end
end
