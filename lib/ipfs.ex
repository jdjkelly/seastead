defmodule Ipfs do
  def add(path) do
    {result, 0} = System.cmd "ipfs", ["add", path]
  end

  def add_dir(path) do
    {result, 0} = System.cmd "ipfs", ["add", path, "-r"]
  end
end
