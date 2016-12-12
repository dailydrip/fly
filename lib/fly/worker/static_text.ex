defmodule Fly.Worker.StaticText do
  @moduledoc """
  StaticText is an example worker for Fly that always returns some static text,
  ignoring the input binary entirely.
  """

  @doc """
  Returns a static string.  Ignores all arguments.
  """
  def call(_input, _config) do
    "giggity"
  end
end
