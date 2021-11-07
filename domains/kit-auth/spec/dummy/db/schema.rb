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

ActiveRecord::Schema.define(version: 2021_10_25_161054) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "uid", null: false
    t.string "name", null: false
    t.string "scopes", default: "", null: false
    t.jsonb "data", default: {}, null: false
    t.index ["deleted_at"], name: "index_applications_on_deleted_at"
    t.index ["uid"], name: "index_applications_on_uid"
  end

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

  create_table "user_oauth_identities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "provider_uid", null: false
    t.jsonb "data", default: {}, null: false
    t.index ["deleted_at"], name: "index_user_oauth_identities_on_deleted_at"
    t.index ["provider", "provider_uid", "deleted_at"], name: "index_user_oauth_providers_deleted_at"
    t.index ["provider", "provider_uid"], name: "index_user_oauth_providers_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["provider"], name: "index_user_oauth_identities_on_provider"
    t.index ["provider_uid"], name: "index_user_oauth_identities_on_provider_uid"
    t.index ["user_id"], name: "index_user_oauth_identities_on_user_id"
  end

  create_table "user_oauth_secrets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "user_oauth_identity_id", null: false
    t.string "provider_app_id", null: false
    t.text "secret_token", null: false
    t.text "secret_refresh_token"
    t.datetime "expires_at"
    t.index ["deleted_at"], name: "index_user_oauth_secrets_on_deleted_at"
    t.index ["user_oauth_identity_id", "provider_app_id", "secret_token", "deleted_at"], name: "index_user_oauth_secrets_token_deleted_at"
    t.index ["user_oauth_identity_id", "provider_app_id", "secret_token"], name: "index_user_oauth_secrets_token_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["user_oauth_identity_id"], name: "index_user_oauth_secrets_on_user_oauth_identity_id"
  end

  create_table "user_secrets", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "application_id", null: false
    t.bigint "user_id", null: false
    t.string "category", null: false
    t.string "scopes", null: false
    t.string "secret", null: false
    t.string "secret_strategy", null: false
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.jsonb "data", default: {}, null: false
    t.index ["application_id"], name: "index_user_secrets_on_application_id"
    t.index ["category"], name: "index_user_secrets_on_category"
    t.index ["deleted_at", "secret", "secret_strategy"], name: "index_user_secrets_on_deleted_at_and_secret_and_secret_strategy"
    t.index ["deleted_at", "user_id"], name: "index_user_secrets_on_deleted_at_and_user_id"
    t.index ["deleted_at"], name: "index_user_secrets_on_deleted_at"
    t.index ["scopes"], name: "index_user_secrets_on_scopes"
    t.index ["secret", "secret_strategy"], name: "index_user_secrets_unique_secret", unique: true, where: "(deleted_at IS NULL)"
    t.index ["secret"], name: "index_user_secrets_on_secret"
    t.index ["secret_strategy"], name: "index_user_secrets_on_secret_strategy"
    t.index ["user_id"], name: "index_user_secrets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "email", null: false
    t.datetime "email_confirmed_at"
    t.string "hashed_secret"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email", "deleted_at"], name: "index_users_on_email_and_deleted_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["email"], name: "index_users_on_email_unique", unique: true, where: "(deleted_at IS NULL)"
    t.index ["email_confirmed_at"], name: "index_users_on_email_confirmed_at"
  end

  add_foreign_key "user_oauth_identities", "users"
  add_foreign_key "user_oauth_secrets", "user_oauth_identities"
  add_foreign_key "user_secrets", "applications"
  add_foreign_key "user_secrets", "users"
end
