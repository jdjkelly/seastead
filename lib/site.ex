defmodule Site do
  def start_link({host, path}) do
    Agent.start_link(fn -> {{host, path}, %{}} end, name: __MODULE__)
  end

  def get(:url) do
    Agent.get __MODULE__, fn {{host, path}, _} -> {host, path} end
  end

  def get(path) do
    Agent.get __MODULE__, fn {_, state} ->
      Dict.has_key?(state, path)
    end
  end

  def get do
    Agent.get __MODULE__, fn state -> state end
  end

  def set(path, body) do
    Agent.update __MODULE__, fn {url, state} ->
      spawn fn -> Snapshot.start({path, body}) end
      {url, Map.put(state, path, body)}
    end
  end
end
