defmodule Snapshot do
  #@todo support saving the path as the file-extension name when it's present
  def start({url, body}) do
    %URI{host: host, path: path} = URI.parse(url)
    File.write(dir({host, path}) <> "index.html", body)
  end

  defp mkdir(path) do
    path |> File.mkdir_p
    path
  end

  #@todo accept arbitrary path from options
  defp dir({host, path}) do
    {:ok, cp} = File.cwd()
    cp <> "/dump/" <> host <> path
  end
end
