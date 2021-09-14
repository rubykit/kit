# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_10_140620) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.jsonb "data", default: {}, null: false
    t.jsonb "metadata", default: {}, null: false
    t.index ["created_at", "deleted_at"], name: "index_events_on_created_at_and_deleted_at"
    t.index ["data"], name: "index_events_on_data", using: :gin
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
    t.index ["id", "deleted_at"], name: "index_events_on_id_and_deleted_at"
    t.index ["metadata"], name: "index_events_on_metadata", using: :gin
    t.index ["name", "deleted_at"], name: "index_events_on_name_and_deleted_at"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "revoked_at"
    t.datetime "deleted_at"
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "scopes"
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["deleted_at"], name: "index_oauth_access_grants_on_deleted_at"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token"
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "revoked_at"
    t.datetime "deleted_at"
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "hash_strategy"
    t.string "scopes"
    t.integer "expires_in"
    t.text "refresh_token"
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["deleted_at"], name: "index_oauth_access_tokens_on_deleted_at"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token"
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token"
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.index ["deleted_at"], name: "index_oauth_applications_on_deleted_at"
    t.index ["uid"], name: "index_oauth_applications_on_uid"
  end

  create_table "oauth_identities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.text "token", null: false
    t.integer "expires_at"
    t.jsonb "info"
    t.jsonb "extra"
    t.index ["deleted_at"], name: "index_oauth_identities_on_deleted_at"
    t.index ["provider", "uid", "deleted_at"], name: "index_oauth_identities_on_provider_and_uid_and_deleted_at"
    t.index ["provider", "uid"], name: "index_oauth_identities_on_provider_and_uid", unique: true, where: "(deleted_at IS NULL)"
    t.index ["provider"], name: "index_oauth_identities_on_provider"
    t.index ["uid"], name: "index_oauth_identities_on_uid"
    t.index ["user_id"], name: "index_oauth_identities_on_user_id"
  end

  create_table "request_metadata", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "user_id"
    t.inet "ip", null: false
    t.text "user_agent", null: false
    t.jsonb "utm"
    t.index ["created_at"], name: "index_request_metadata_on_created_at"
    t.index ["deleted_at"], name: "index_request_metadata_on_deleted_at"
    t.index ["user_id"], name: "index_request_metadata_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "email", null: false
    t.string "hashed_secret"
    t.datetime "confirmed_at"
    t.index ["confirmed_at"], name: "index_users_on_confirmed_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email", "deleted_at"], name: "index_users_on_email_and_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["email"], name: "index_users_on_email_unique", unique: true, where: "(deleted_at IS NULL)"
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "oauth_identities", "users"
end
