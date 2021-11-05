defmodule Sentinel do
  @moduledoc """
  Documentation for `Sentinel`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Sentinel.hello()
      :world

  """
  def hello do
    :world
  end

  def search(crawl_id, query_string) do
    # query search service for result ids
    result_page_ids = get_result_page_ids(crawl_id, query_string)

    # get result pages
    get_result_pages(crawl_id, result_page_ids)
  end

  def get_result_page_ids(crawl_id, query_string) do
    # format search query
    search_url = "http://localhost:4000/search/#{crawl_id}?#{query_string}"

    # make request to septavius (search service) and return the response (list of result ids)
    get_request(search_url)["data"]
  end

  def get_result_pages(crawl_id, ids) do
    # comma separated list of ids
    ids_string = Enum.join(ids, ",")

    # format search query
    pages_url = "http://localhost:3000/crawls/#{crawl_id}/pages?ids=#{ids_string}"

    # make request to oryx (data service) and return the response (list of pages)
    get_request(pages_url)
  end

  def fetch_page(id) do
    # format the request url
    page_url = "http://localhost:3000/pages/#{id}"

    # make request to oryx (data service) and return the response
    get_request(page_url)
  end

  def get_request(url) do
    # make request to oryx (data service)
    {:ok, response} = HTTPoison.get(url)

    # return the response (list of pages)
    Jason.decode!(response.body)
  end
end
