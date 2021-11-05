class CrawlHasPages < ActiveRecord::Migration[6.0]
  def change
    add_reference :pages, :crawl, foreign_key: true
  end
end
