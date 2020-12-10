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

ActiveRecord::Schema.define(version: 2019_12_08_143026) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "kit_json_api_spec_authors", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "name", null: false
    t.date "date_of_birth", null: false
    t.date "date_of_death"
  end

  create_table "kit_json_api_spec_books", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "kit_json_api_spec_author_id"
    t.bigint "kit_json_api_spec_serie_id"
    t.text "title", null: false
    t.date "date_published", null: false
    t.index ["kit_json_api_spec_author_id"], name: "index_kit_json_api_spec_books_on_kit_json_api_spec_author_id"
    t.index ["kit_json_api_spec_serie_id"], name: "index_kit_json_api_spec_books_on_kit_json_api_spec_serie_id"
  end

  create_table "kit_json_api_spec_books_stores", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "kit_json_api_spec_book_id", null: false
    t.bigint "kit_json_api_spec_store_id", null: false
    t.boolean "in_stock"
    t.index ["kit_json_api_spec_book_id"], name: "index_kjas_books_stores_on_kjas_book_id"
    t.index ["kit_json_api_spec_store_id"], name: "index_kjas_books_stores_on_kjas_store_id"
  end

  create_table "kit_json_api_spec_chapters", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "kit_json_api_spec_book_id"
    t.text "title", null: false
    t.integer "index", null: false
    t.index ["kit_json_api_spec_book_id"], name: "index_kit_json_api_spec_chapters_on_kit_json_api_spec_book_id"
  end

  create_table "kit_json_api_spec_photos", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "imageable_type"
    t.bigint "imageable_id"
    t.text "title", null: false
    t.text "uri", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_kjas_photos_on_imageable_type_and_imageable_id"
  end

  create_table "kit_json_api_spec_series", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "title"
  end

  create_table "kit_json_api_spec_stores", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "name", null: false
  end

  add_foreign_key "kit_json_api_spec_books", "kit_json_api_spec_authors"
  add_foreign_key "kit_json_api_spec_books", "kit_json_api_spec_series", column: "kit_json_api_spec_serie_id"
  add_foreign_key "kit_json_api_spec_books_stores", "kit_json_api_spec_books"
  add_foreign_key "kit_json_api_spec_books_stores", "kit_json_api_spec_stores"
  add_foreign_key "kit_json_api_spec_chapters", "kit_json_api_spec_books"
end
