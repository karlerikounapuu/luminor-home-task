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

ActiveRecord::Schema[8.1].define(version: 2025_11_13_171035) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "configuration_item_relationships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "relationship_type_id", null: false
    t.uuid "source_configuration_item_id", null: false
    t.uuid "target_configuration_item_id", null: false
    t.datetime "updated_at", null: false
    t.index ["relationship_type_id"], name: "index_configuration_item_relationships_on_relationship_type_id"
    t.index ["source_configuration_item_id", "target_configuration_item_id", "relationship_type_id"], name: "unique_configuration_item_relationship", unique: true
    t.index ["source_configuration_item_id"], name: "idx_on_source_configuration_item_id_af958287c9"
    t.index ["target_configuration_item_id"], name: "idx_on_target_configuration_item_id_9e4bd7a1da"
    t.check_constraint "source_configuration_item_id <> target_configuration_item_id", name: "no_ci_relationship_self_reference"
  end

  create_table "configuration_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description"
    t.uuid "item_environment_id", null: false
    t.uuid "item_status_id", null: false
    t.uuid "item_type_id", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["item_environment_id"], name: "index_configuration_items_on_item_environment_id"
    t.index ["item_status_id"], name: "index_configuration_items_on_item_status_id"
    t.index ["item_type_id"], name: "index_configuration_items_on_item_type_id"
    t.index ["name"], name: "index_configuration_items_on_name", unique: true
  end

  create_table "item_environments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_item_environments_on_name", unique: true
  end

  create_table "item_statuses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_item_statuses_on_name", unique: true
  end

  create_table "item_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_item_types_on_name", unique: true
  end

  create_table "relationship_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_relationship_types_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "configuration_item_relationships", "configuration_items", column: "source_configuration_item_id"
  add_foreign_key "configuration_item_relationships", "configuration_items", column: "target_configuration_item_id"
  add_foreign_key "configuration_item_relationships", "relationship_types"
  add_foreign_key "configuration_items", "item_environments"
  add_foreign_key "configuration_items", "item_statuses"
  add_foreign_key "configuration_items", "item_types"
end
