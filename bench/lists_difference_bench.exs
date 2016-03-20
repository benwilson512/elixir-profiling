defmodule ListsDifferenceBench do
  use Benchfella

  @size 10_00
  @biglist 0..@size |> Enum.map(fn _ -> :erlang.unique_integer end)

  @interval 10
  for i <- 20..25 do
    @n i * @interval
    @list1 0..(2 * @n) |> Enum.map(fn n -> :erlang.unique_integer end)
    @list2 0..@n |> Enum.map(fn n -> :erlang.unique_integer end)
    bench "Lists -- #{2 * @n}, #{@n}" do
      MyList.subtract(@list1, @list2)
    end

    bench "MapSet diff #{2 * @n}, #{@n}" do
      MyList.mapset_subtract(@list1, @list2)
    end
  end

  # bench "Lists -- #{@size}, 1" do
  #   MyList.subtract(@biglist, [1])
  # end
end
