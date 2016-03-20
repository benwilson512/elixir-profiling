defmodule MapSetIntersectionBench do
  use Benchfella
  @size 10_000
  @bigset 0..@size |> MapSet.new

  @interval 1_000
  for i <- 1..10 do
    @n i * @interval
    @smallset MapSet.new(0..@n)

    bench "MapSet.intersection #{@size},  #{@n}" do
      MapSet.intersection(@bigset, @smallset)
    end

    bench "MyMapSet.intersection #{@size},  #{@n}" do
      MyMapSet.intersection(@bigset, @smallset)
    end
  end
end
