module IndexDataRequestPagerankComplete
  class Service
    def initialize(crawl_id, page_ranks)
      @crawl_id = crawl_id
      @page_ranks = page_ranks
      call
    end

    def call
      # Get the current crawl
      crawl = Crawl.find(crawl_id)

      # Update each crawled page with the page rank
      crawl.pages.each do |page|
        page.update!(page_rank: page_ranks[page.url])
      end

      # Format message for the indexer
      message = {
        crawl_id: crawl_id,
        pages: crawl.pages
      }

      # Send message to kafka
      DeliveryBoy.deliver(message.to_json, topic: 'index_data_request_complete')
    end

    private

    attr_reader :crawl_id, :page_ranks
  end
end
