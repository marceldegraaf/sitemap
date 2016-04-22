defmodule ExSitemapGenerator.Namer do
  alias ExSitemapGenerator.NameError

  defstruct [
    base: "",
    ext: ".xml.gz",
    zero: nil,
    start: 1,
    count: nil,
  ]

  use ExSitemapGenerator.State

  def init(name), do: start_link(name)

  def to_string(name) do
    s = state(name)
    "#{s.base}#{s.count}#{s.ext}"
  end

  def reset(name) do
    update_state name, :count, state.zero
  end

  def start?(name) do
    s = state(name)
    s.count == s.zero
  end

  def next(name) do
    if start?(name) do
      update_state name, :count, state.start
    else
      incr_state name, :count
    end
  end

  def previous!(name) do
    if start?(name), do: raise NameError,
        message: "Already at the start of the series"

    s = state(name)
    if s.count <= s.start do
      update_state name, :count, state.zero
    else
      decr_state name, :count
    end
  end

end
