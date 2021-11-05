class AddPageRankToPage < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :page_rank, :float
  end
end
