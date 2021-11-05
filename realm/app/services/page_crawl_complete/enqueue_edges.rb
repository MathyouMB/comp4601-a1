module PageCrawlComplete
  class EnqueueEdges
    def initialize(links)
      @links = links
      call
    end

    def call
      links.each do |link|
        Rails.logger.debug(link)
        break if Crawl.last.reached_max_pages?

        page = Crawl.last.queued_pages.find_by(url: link)
        next unless page.nil?
        next unless correct_host?(link)
        next if file?(link)

        message = {
          'crawl_id' => Crawl.last.id,
          'url' => link
        }

        QueuedPage.create!(url: link, crawl_id: Crawl.last.id)
        DeliveryBoy.deliver(message.to_json, topic: 'page-crawl-enqueue')
      end
    end

    private

    def correct_host?(link)
      uri_1 = URI.parse(link)
      uri_2 = URI.parse(Crawl.last.url)
      Rails.logger.debug(uri_1.path)
      Rails.logger.debug(uri_1.host)
      Rails.logger.debug(uri_2.path)
      Rails.logger.debug(uri_2.host)
      Rails.logger.debug(uri_1.host == uri_2.host)
      Rails.logger.debug(uri_1.path.include?(uri_2.path))
      uri_1.host == uri_2.host # && uri_1.path.include?(uri_2.path)
    rescue StandardError
      false
    end

    def file?(link)
      link.end_with?('.pdf') || link.end_with?('.doc') || link.end_with?('.docx') || link.end_with?('.xls') || link.end_with?('.xlsx') || link.starts_with?('mailto')
    end

    attr_reader :links
  end
end
