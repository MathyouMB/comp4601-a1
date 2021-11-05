class CreateQueuedPages < ActiveRecord::Migration[6.0]
  def change
    create_table :queued_pages do |t|
      t.text :url

      t.timestamps
    end
  end
end
