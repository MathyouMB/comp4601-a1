# frozen_string_literal: true

class CreateEdges < ActiveRecord::Migration[6.0]
  def change
    create_table :edges do |t|
      t.text :parent
      t.text :child

      t.timestamps
    end
  end
end
