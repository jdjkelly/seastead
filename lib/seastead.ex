defmodule Seastead do
  def main([url]) do
    url |> Crawler.start
  end
end
