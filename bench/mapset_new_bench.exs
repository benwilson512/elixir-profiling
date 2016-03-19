defmodule MapSetNewBench do
  use Benchfella

  @interval 1_000
  for i <- 1..10 do
    @n i * @interval
    @range 0..@n
    bench "MapSet.new(#{inspect @range})" do
      MapSet.new(@range)
    end

    bench "MyMapSet.new(#{inspect @range})" do
      MyMapSet.new(@range)
    end
  end
end
