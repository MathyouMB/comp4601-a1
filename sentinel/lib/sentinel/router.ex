defmodule Sentinel.Router do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["text/html", "application/json"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    render_json(conn, %{"data" => "hello world"})
  end

  get "/fruits" do
    fruits_crawl_id = 1
    search_results = Sentinel.search(fruits_crawl_id, conn.query_string)
    render_json(conn, %{"data" => search_results})
  end

  get "/personal" do
    personal_crawl_id = 2
    search_results = Sentinel.search(personal_crawl_id, conn.query_string)
    render_json(conn, %{"data" => search_results})
  end

  get "/pages/:id" do
    page = Sentinel.fetch_page(id)
    render_json(conn, %{"data" => page})
  end

  match _ do
    send_resp(conn, 404, "404")
  end

  defp render_json(%{status: status} = conn, data) do
    body = Jason.encode!(data)
    send_resp(conn, status || 200, body)
  end
end
