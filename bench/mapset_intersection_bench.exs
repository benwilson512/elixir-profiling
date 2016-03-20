defmodule MapSetIntersectionBench do
  use Benchfella
  @bigsize 10_000
  @bigset 0..@bigsize |> MapSet.new

  @interval 1_000
  for i <- 1..10 do
    @n i * @interval
    @smallmap MapSet.new(100_000..(100_000 + @n))
    # bench "MapSet.intersection #{@bigsize},  #{@n}" do
    #   MapSet.intersection(@bigset, @smallmap)
    # end

    bench "MyMapSet.intersection #{@bigsize},  #{@n}" do
      MyMapSet.intersection(@bigset, @smallmap)
    end
  end
end
