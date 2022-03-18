defmodule Telecms.Utils do
  def deep_merge(patch, state) when is_map(state) and is_map(patch) do
    Map.merge(state, patch, fn _k, v1, v2 -> deep_merge(v2, v1) end)
  end

  def deep_merge(patch, state) when is_list(state) and is_list(patch) do
    state ++ patch
  end

  def deep_merge(patch, _state), do: patch
end
