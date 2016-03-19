defmodule Utils do
  def random_list(n, fun) do
    do_random_list(n, fun, [])
  end

  def do_random_list(0, _, list), do: list
  def do_random_list(n, fun, list) do
    do_random_list(n - 1, fun, [fun.(n) | list])
  end
end
