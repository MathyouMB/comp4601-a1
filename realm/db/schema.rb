# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_05_011008) do

  create_table "crawls", force: :cascade do |t|
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "max_pages"
  end

  create_table "edges", force: :cascade do |t|
    t.text "parent"
    t.text "child"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "crawl_id"
    t.index ["crawl_id"], name: "index_edges_on_crawl_id"
  end

  create_table "pages", force: :cascade do |t|
    t.text "url"
    t.text "html"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "crawl_id"
    t.text "title"
    t.float "page_rank"
    t.index ["crawl_id"], name: "index_pages_on_crawl_id"
  end

  create_table "queued_pages", force: :cascade do |t|
    t.text "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "crawl_id"
    t.index ["crawl_id"], name: "index_queued_pages_on_crawl_id"
  end

  add_foreign_key "edges", "crawls"
  add_foreign_key "pages", "crawls"
  add_foreign_key "queued_pages", "crawls"
end
