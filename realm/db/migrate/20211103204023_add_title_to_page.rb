class AddTitleToPage < ActiveRecord::Migration[6.0]
  def change
    add_column :pages, :title, :text
  end
end
