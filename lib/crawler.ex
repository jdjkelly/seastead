defmodule Crawler do
  alias HTTPoison, as: HTTP

  def start(url) do
    %URI{host: host, path: path} = URI.parse(url)
    Site.start_link({host, path})
    crawl(url)
  end

  defp crawl(url, []) do
    crawl(url)
  end

  defp crawl(url, [head|tail]) do
    crawl(url)
    crawl(head, tail)
  end

  defp crawl(url) do
    %URI{host: host, path: path, scheme: scheme} = URI.parse(url)
    url = scheme <> "://" <> host <> path
    if !Site.get(url) do
      IO.puts "Crawling " <> url
      get(HTTP.get(url), url)
    end
  end

  def get({:ok, %HTTP.Response{status_code: 200, body: body}}, url) do
    Site.set(url, body)
    crawl(url, parse_hrefs(body) |> Enum.filter(fn(url) -> matches?(url) end))
  end

  def get({:ok, %HTTP.Response{status_code: 301, headers: [_, {"Location", location}, _]}}, _) do
    get(HTTP.get(location), location)
  end

  def get({:ok, %HTTP.Response{status_code: 404}}, _) do
    :error
  end

  def get({:error, %HTTP.Error{}}, _) do
    :error
  end

  defp parse_hrefs(body) do
    body |> Floki.find("a") |> Floki.attribute("href")
  end

  # @todo relative URLs
  defp matches?(url) do
    {host, path} = Site.get(:url)
    Regex.run(~r/(?:http|https):\/\/#{host}#{path}.*/i, url)
  end
end
