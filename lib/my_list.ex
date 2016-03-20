defmodule MyList do
  def mapset_subtract(list1, list2) do
    list1
    |> MapSet.new
    |> MapSet.difference(MapSet.new(list2))
  end

  def subtract(list1, list2) do
    list1 -- list2
  end
end
