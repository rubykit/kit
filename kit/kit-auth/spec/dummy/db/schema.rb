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

ActiveRecord::Schema.define(version: 2019_04_18_064850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "oauth_access_grants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.string "scopes"
    t.datetime "revoked_at"
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
    t.text "refresh_token"
    t.integer "expires_in"
    t.string "scopes"
    t.datetime "revoked_at"
    t.string "previous_refresh_token", default: "", null: false
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
    t.text "secret"
    t.integer "expires_at"
    t.jsonb "info"
    t.jsonb "extra"
    t.index ["deleted_at"], name: "index_oauth_identities_on_deleted_at"
    t.index ["provider", "uid", "deleted_at"], name: "index_oauth_identities_on_provider_and_uid_and_deleted_at", unique: true, where: "(deleted_at IS NULL)"
    t.index ["provider"], name: "index_oauth_identities_on_provider"
    t.index ["token"], name: "index_oauth_identities_on_token"
    t.index ["uid"], name: "index_oauth_identities_on_uid"
    t.index ["user_id"], name: "index_oauth_identities_on_user_id"
  end

  create_table "user_action_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "category"
    t.bigint "user_id", null: false
    t.text "token", null: false
    t.integer "expires_in", default: 0
    t.datetime "used_at"
    t.index ["deleted_at"], name: "index_user_action_tokens_on_deleted_at"
    t.index ["token"], name: "index_user_action_tokens_on_token"
    t.index ["user_id"], name: "index_user_action_tokens_on_user_id"
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
    t.index ["email", "deleted_at"], name: "index_users_on_email_and_deleted_at", unique: true, where: "(deleted_at IS NULL)"
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "oauth_identities", "users"
  add_foreign_key "user_action_tokens", "users"
end
