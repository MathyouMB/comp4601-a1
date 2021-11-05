class Crawl < ApplicationRecord
  # relations
  has_many :edges, dependent: :delete_all
  has_many :pages, dependent: :delete_all
  has_many :queued_pages, dependent: :delete_all

  # validations
  validates :url, presence: true
  validates :max_pages, presence: true

  def reached_max_pages?
    queued_pages.count >= max_pages
  end
end
