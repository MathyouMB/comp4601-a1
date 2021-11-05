# frozen_string_literal: true

class Page < ApplicationRecord
  belongs_to :crawl
  validates :url, presence: true
  validates :title, presence: true

  def search_view
    {
      id: id,
      url: url,
      title: title
    }
  end

  def detailed_view
    {
      id: id,
      url: url,
      title: title,
      html: html,
      page_rank: page_rank,
      incoming: inbound_urls,
      outgoing: outbound_urls,
      word_frequency: word_frequency
    }
  end

  # Inbound links are links that come from other websites or a different domain name
  def inbound_edges
    Edge.where(child: url)
  end

  def inbound_urls
    inbound_edges.map(&:parent)
  end

  # Outbound links are those links on your website that link out to websites with a different domain name.
  def outbound_edges
    Edge.where(parent: url)
  end

  def outbound_urls
    outbound_edges.map(&:child)
  end

  def neigbours
    {
      inbound: inbound_urls,
      outbound: outbound_urls
    }
  end

  def word_frequency
    words = html.split(' ')
    frequency = Hash.new(0)
    words.each { |word| frequency[word.downcase] += 1 }
    return frequency
  end

  def state
    {
      id: id,
      url: url,
      html: html,
      neightbours: neigbours
    }
  end
end
