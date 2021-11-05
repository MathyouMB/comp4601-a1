class QueuedHasCrawl < ActiveRecord::Migration[6.0]
  def change
    add_reference :queued_pages, :crawl, foreign_key: true
  end
end
