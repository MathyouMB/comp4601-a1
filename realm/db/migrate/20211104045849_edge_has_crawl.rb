class EdgeHasCrawl < ActiveRecord::Migration[6.0]
  def change
    add_reference :edges, :crawl, foreign_key: true
  end
end
