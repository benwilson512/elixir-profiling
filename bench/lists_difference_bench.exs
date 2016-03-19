defmodule ListsDifferenceBench do
  use Benchfella

  @size 10_000
  @biglist1 1..@size |> Enum.to_list

  @interval 1_000
  for i <- 1..20 do
    @n i * @interval
    @smalllist 0..@n |> Enum.to_list
    bench "Lists -- #{@size}, #{@n}" do
      MyList.subtract(@biglist1, @smalllist)
    end

    bench "Lists -- #{@n}, #{@size}" do
      MyList.subtract(@smalllist, @biglist1)
    end
  end

  bench "Lists -- #{@size}, 1" do
    MyList.subtract(@biglist1, [1])
  end

  bench "Lists -- 1, #{@size}" do
    MyList.subtract([1], @biglist1)
  end
end
