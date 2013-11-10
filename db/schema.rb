# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131110015807) do

  create_table "links", force: true do |t|
    t.integer "to_id"
    t.integer "from_id"
  end

  add_index "links", ["from_id"], name: "index_links_on_from_id", using: :btree
  add_index "links", ["to_id"], name: "index_links_on_to_id", using: :btree

  create_table "pages", force: true do |t|
    t.string  "title"
    t.integer "page_ident"
    t.integer "wiki_id"
  end

  create_table "wikis", force: true do |t|
    t.string "title"
  end

end
