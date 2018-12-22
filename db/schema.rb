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

ActiveRecord::Schema.define(version: 20181204215035) do

  create_table "authors", force: :cascade do |t|
    t.string "author_type"
    t.string "author_id"
    t.string "name"
    t.string "image_url"
  end

  create_table "conversation_parts", force: :cascade do |t|
    t.integer "conversation_part_id", limit: 8
    t.text "conversation_part_body"
    t.integer "conversation_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "creation_date"
    t.text "sanitized_conversation_part_body"
    t.string "author_id"
    t.index ["conversation_id"], name: "index_conversation_parts_on_conversation_id"
  end

  create_table "conversation_tags", force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "tag_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "conversation_id", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer "tag_id", limit: 8
    t.string "name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
