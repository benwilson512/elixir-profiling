defmodule MapSetDisjointBench do
  use Benchfella

  @interval 1_000
  for i <- 1..10 do
    @n i * @interval
    @set1 MapSet.new(0..@n)
    @set2 MapSet.new(100_000..(100_000 + @n))
    bench "MapSet.disjoint? #{@n}, #{@n}" do
      MapSet.disjoint?(@set1, @set2)
    end

    bench "MyMapSet.disjoint? #{@n}, #{@n}" do
      MyMapSet.disjoint?(@set1, @set2)
    end
  end

end
