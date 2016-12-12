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
end
