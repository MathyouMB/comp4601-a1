# frozen_string_literal: true

class Page < ApplicationRecord
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

  def state
    {
      id: id,
      url: url,
      html: html,
      neightbours: neigbours
    }
  end
end
