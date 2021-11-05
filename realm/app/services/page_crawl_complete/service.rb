module PageCrawlComplete
  class Service
    def initialize(title, url, html, links)
      @title = title
      @url = url
      @html = html
      @links = links
      call
    end

    def call
      # check if page is already in database
      page = Crawl.last.pages.find_by(url: url)

      # if the page has not been crawled yet, create a new page and enqueue it's edges
      return unless page.nil?

      # if not in db, save page
      PageCrawlComplete::SavePage.new(title, url, html)

      # if links were found, save links as edges
      PageCrawlComplete::CreatePageEdges.new(url, links) unless links.empty?

      # enqueue all edge nodes to kafka
      PageCrawlComplete::EnqueueEdges.new(links) unless links.empty?
    end

    private

    attr_reader :title, :url, :html, :links
  end
end
