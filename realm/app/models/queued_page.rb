# frozen_string_literal: true

class QueuedPage < ApplicationRecord
  belongs_to :crawl
  validates :url, presence: true
end
