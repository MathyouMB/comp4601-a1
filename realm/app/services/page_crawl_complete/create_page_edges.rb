module PageCrawlComplete
  class CreatePageEdges
    def initialize(url, links)
      @url = url
      @links = links
      call
    end

    def call
      crawl_id = Crawl.last.id
      links.each do |link|
        next if link.nil?
        Edge.create!(parent: url, child: link, crawl_id: crawl_id) if Edge.where(parent: url, child: link, crawl_id: crawl_id).empty?
      end
    end

    private

    attr_reader :url, :links
  end
end
