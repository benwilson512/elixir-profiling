defmodule MyMapSet do

  def disjoint?(%MapSet{map: map1}, %MapSet{map: map2}) do
    {map1, map2} = order_by_size(map1, map2)

    map1
    |> Map.keys
    |> any_in?(map2)
  end

  defp any_in?([], _) do
    true
  end
  defp any_in?([k | rest], map2) do
    case Map.has_key?(map2, k) do
      true -> false
      false -> any_in?(rest, map2)
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

  # If the first set is less than twice the size of the second map,
  # it is fastest to re-accumulate items in the first set that are not
  # present in the second set.
  def difference(%MapSet{map: map1}, %MapSet{map: map2})
    when map_size(map1) < map_size(map2) * 2 do

    map = map1
    |> Map.keys
    |> do_difference(map2, [])

    %MapSet{map: map}
  end

  # If the second set is less than half the size of the first set, it's fastest
  # to simply iterate through each item in the second set, deleting them from
  # the first set.
  def difference(%MapSet{map: map1}, %MapSet{map: map2}) do
    map = map2
    |> Map.keys
    |> delete_from(map1)

    %MapSet{map: map}
  end

  def delete_from([], acc), do: acc
  def delete_from([k | rest], acc) do
    delete_from(rest, Map.delete(acc, k))
  end

  def do_difference([], _map2, acc) do
    acc |> :maps.from_list
  end
  def do_difference([k | rest], map2, acc) do
    acc = if Map.has_key?(map2, k) do
      acc
    else
      [{k, true} | acc]
    end
    do_difference(rest, map2, acc)
  end

  def intersection(%MapSet{map: map1}, %MapSet{map: map2}) do
    {map1, map2} = order_by_size(map1, map2)

    map = map1
    |> Map.keys
    |> acc_intersection(map2, [])

    %MapSet{map: map}
  end

  defp acc_intersection([], _map2, acc), do: :maps.from_list(acc)
  defp acc_intersection([k | rest], map2, acc) do
    acc = if Map.has_key?(map2, k) do
      [{k, true} | acc]
    else
      acc
    end
    acc_intersection(rest, map2, acc)
  end

  defp order_by_size(map1, map2) when map_size(map1) > map_size(map2), do: {map2, map1}
  defp order_by_size(map1, map2), do: {map1, map2}
end
