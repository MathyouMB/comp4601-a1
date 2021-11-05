class CrawlsController < ApplicationController
  def index
    render json: Crawl.all
  end

  def pages
    crawl = Crawl.find(params[:id])

    if params['ids'].nil?
      render json: crawl.pages
    else
      id_list = params['ids'].split(',')
      result = crawl.pages.where(id: id_list).map(&:search_view)
      render json: result
    end
  rescue StandardError
    render json: { error: 'Error fetching crawl.' }, status: :not_found
  end

  def create
    crawl = Crawl.create!(
      url: params[:crawl][:url],
      max_pages: params[:crawl][:max_pages]
    )

    message = {
      'crawl_id' => crawl.id,
      'url' => crawl.url
    }

    DeliveryBoy.deliver(message.to_json, topic: 'page-crawl-enqueue')
    render json: crawl
  rescue StandardError
    render json: { error: 'Error starting crawl.' }, status: :internal_server_error
  end
end
