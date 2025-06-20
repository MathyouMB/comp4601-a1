# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.text :url
      t.text :html

      t.timestamps
    end
  end
end
