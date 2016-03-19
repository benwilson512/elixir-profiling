defmodule MyMapSet do

  def disjoint?(%MapSet{map: map1}, %MapSet{map: map2}) do
    {map1, map2} = order_by_size(map1, map2)
    map1
    |> :maps.to_list
    |> do_disjoint(map2)
  end

  defp do_disjoint([], _) do
    true
  end
  defp do_disjoint([{k, _} | rest], map2) do
    case Map.has_key?(map2, k) do
      true -> false
      false -> do_disjoint(rest, map2)
    end
  end

  def new(enumerable) do
    map = enumerable
    |> Enum.reduce([], &[{&1, true} | &2])
    |> :maps.from_list

    %MapSet{map: map}
  end

  def new(enumerable, transform) do
    map = enumerable
    |> Enum.reduce([], &[{transform.(&1), true} | &2])
    |> :maps.from_list

    %MapSet{map: map}
  end

  # Map equality is a very quick check.
  # If the two sets are equal, we can return an empty set
  def difference(%MapSet{map: map}, %MapSet{map: map}) do
    %MapSet{map: %{}}
  end
  # If the first set is less than twice the size of the second map,
  # it is fastest to re-accumulate items in the first set that are not
  # present in the second set.
  def difference(%MapSet{map: map1}, %MapSet{map: map2})
    when map_size(map2) * 2 > map_size(map1) do

    map = :maps.fold(fn k, v, acc ->
      case Map.fetch(map2, k) do
        {:ok, _} -> acc
        :error -> [{k, v} | acc]
      end
    end, [], map1)
    |> :maps.from_list

    %MapSet{map: map}
  end

  # If the second set is less than half the size of the first set, it's fastest
  # to simply iterate through each item in the second set, deleting them from
  # the first set.
  def difference(%MapSet{map: map1}, %MapSet{map: map2}) do
    map = :maps.fold(fn value, _, acc ->
      Map.delete(acc, value)
    end, map1, map2)
    %MapSet{map: map}
  end

  def intersection(%MapSet{map: map1}, %MapSet{map: map2}) do
    {map1, map2} = order_by_size(map1, map2)

    map = :maps.fold(fn key, value, acc ->
      if Map.has_key?(map2, value) do
        [{key, value} | acc]
      else
        acc
      end
    end, [], map1)
    |> :maps.from_list

    %MapSet{map: map}
  end

  defp order_by_size(map1, map2) when map_size(map1) > map_size(map2), do: {map2, map1}
  defp order_by_size(map1, map2), do: {map1, map2}
end
