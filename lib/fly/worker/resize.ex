defmodule Fly.Worker.Resize do
  @moduledoc """
  Resize worker for `Fly`.

  `Fly.Worker.Resize` is an example worker for Fly that retains the input file's
  filetype but resizes it to the specified configuration that's passed at
  runtime.
  """

  @doc """
  Resizes the input.

  The `config` argument should have a `size` key whose value is a string that
  will be passed to ImageMagick's `convert` program's `resize` argument.
  """
  def call(input, %{size: size} = config) do
    # - You can specify "-" as a file for convert to read or write that file from
    #   stdin/stdout.
    # - We're also passing "-strip" so that we don't write ancillary metadata
    #   like the modification time into the PNG itself.
    %Porcelain.Result{out: output, status: status} =
      Porcelain.exec("convert", ["-", "-strip", "-resize", size, "-"], [in: input, out: :string])

    output
  end
end
