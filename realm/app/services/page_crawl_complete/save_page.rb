module PageCrawlComplete
  class SavePage
    def initialize(title, url, html)
      @title = title
      @url = url
      @html = html
      call
    end

    def call
      Page.create!(title: title, url: url, html: html, crawl_id: Crawl.last.id)
    end

    private

    attr_reader :title, :url, :html
  end
end
