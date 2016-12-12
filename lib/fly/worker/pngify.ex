defmodule Fly.Worker.Pngify do
  @moduledoc """
  Pngify is an example worker for Fly that converts the input into a `.png` file
  and returns the `.png` content.
  """

  @doc """
  Turns an image into a `.png`.
  """
  def call(input, _config) do
    # - You can specify "-" as a file for convert to read or write that file from
    #   stdin/stdout.
    # - We're also passing "-strip" so that we don't write ancillary metadata
    #   like the modification time into the PNG itself.
    %Porcelain.Result{out: output, status: status} =
      Porcelain.exec("convert", ["-", "-strip", "png:-"], [in: input, out: :string])

    output
  end
end
