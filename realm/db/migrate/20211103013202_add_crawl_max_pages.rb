class AddCrawlMaxPages < ActiveRecord::Migration[6.0]
  def change
    add_column :crawls, :max_pages, :integer
  end
end
