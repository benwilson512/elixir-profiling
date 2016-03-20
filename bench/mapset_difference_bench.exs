defmodule MapSetDifferenceBench do
  use Benchfella

  @size 10_000

  @bigset 0..@size |> MyMapSet.new

  @interval 1_000
  for i <- 1..20 do
    @n i * @interval
    @littleset MyMapSet.new(0..@n)

    bench "MapSet.difference #{@size}, #{@n}" do
      MapSet.difference(@bigset, @littleset)
    end

    bench "MyMapSet.difference #{@size}, #{@n}" do
      MyMapSet.difference(@bigset, @littleset)
    end
  end

  bench "MapSet.difference #{@size}, 1" do
    MapSet.difference(@bigset, MapSet.new([1]))
  end

  bench "MyMapSet.difference #{@size}, 1" do
    MyMapSet.difference(@bigset, MapSet.new([1]))
  end
end
