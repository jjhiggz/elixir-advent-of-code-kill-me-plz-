defmodule HelperMethods do
  def replace_at(list, index, value) do
    list
    |> Enum.with_index()
    |> Enum.map(fn
      {_, ^index} -> value
      {value, _} -> value
    end)
  end
end
