defmodule Blog do
  @moduledoc """
  Documentation for `Blog`.
  """
  import MDEx.Sigil

  @doc """
  Hello world.

  ## Examples

      iex> Blog.hello()
      :world

  """
  def generate do
    ~MD[
      # Testo
      - values
    ]HTML
  end
end
