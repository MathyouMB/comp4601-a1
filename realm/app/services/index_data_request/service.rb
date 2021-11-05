module IndexDataRequest
  class Service
    def initialize(crawl_id)
      @crawl_id = crawl_id
      call
    end

    def call
      crawl = Crawl.find(crawl_id)

      message = {
        crawl_id: crawl.id,
        crawl_edges: crawl.edges.map { |edge| [edge.parent, edge.child] }
      }

      DeliveryBoy.deliver(message.to_json, topic: 'index_data_request_pagerank')
    end

    private

    attr_reader :crawl_id
  end
end
