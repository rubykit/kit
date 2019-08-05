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

ActiveRecord::Schema.define(version: 2019_08_05_114002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "currencies", force: :cascade do |t|
    t.string "iso4217_alpha", limit: 3
    t.string "name"
    t.string "minor_unit", limit: 3
    t.index ["iso4217_alpha"], name: "index_currencies_on_iso4217_alpha"
    t.index ["name"], name: "index_currencies_on_name"
  end

  create_table "event_store_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "event_type", null: false
    t.jsonb "metadata"
    t.jsonb "data", null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
  end

  create_table "event_store_events_in_streams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "stream", null: false
    t.integer "position"
    t.uuid "event_id", null: false
    t.index ["created_at"], name: "index_event_store_events_in_streams_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_in_streams_on_event_id"
    t.index ["stream", "event_id"], name: "index_event_store_events_in_streams_on_stream_and_event_id", unique: true
    t.index ["stream", "position"], name: "index_event_store_events_in_streams_on_stream_and_position", unique: true
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "scopes"
    t.integer "expires_in", null: false
    t.datetime "revoked_at"
    t.text "redirect_uri", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["deleted_at"], name: "index_oauth_access_grants_on_deleted_at"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token"
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "scopes"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.text "refresh_token"
    t.bigint "last_user_request_metadata_id"
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["deleted_at"], name: "index_oauth_access_tokens_on_deleted_at"
    t.index ["last_user_request_metadata_id"], name: "index_oauth_access_tokens_on_last_user_request_metadata_id"
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

  create_table "user_request_metadata", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "user_id", null: false
    t.inet "ip", null: false
    t.text "user_agent", null: false
    t.jsonb "utm"
    t.index ["deleted_at"], name: "index_user_request_metadata_on_deleted_at"
    t.index ["user_id"], name: "index_user_request_metadata_on_user_id"
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
  add_foreign_key "oauth_access_tokens", "user_request_metadata", column: "last_user_request_metadata_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "oauth_identities", "users"
end
