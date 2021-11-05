class Thessal < Racecar::Consumer
  subscribes_to 'page-crawl-complete'
  subscribes_to 'index_data_request'
  subscribes_to 'index_data_request_pagerank_complete'

  def process(message)
    data = JSON.parse(message.value)
    p(message)
    p(DeliveryBoy.config.max_buffer_bytesize)
    p(DeliveryBoy.config.max_buffer_size)
    PageCrawlComplete::Service.new(data['title'], data['url'], data['html'], data['links']) if message.topic == 'page-crawl-complete'
    IndexDataRequest::Service.new(data['crawl_id']) if message.topic == 'index_data_request'
    IndexDataRequestPagerankComplete::Service.new(data['crawl_id'], data['page_ranks']) if message.topic == 'index_data_request_pagerank_complete'
  end
end
