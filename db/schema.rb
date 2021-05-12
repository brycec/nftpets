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

ActiveRecord::Schema.define(version: 2021_05_12_190641) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "furbabies", force: :cascade do |t|
    t.string "dna"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "subject"
    t.string "body"
    t.string "to"
    t.string "from"
    t.bigint "token_id"
    t.index ["token_id"], name: "index_messages_on_token_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "vibes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "furbaby_id"
    t.index ["furbaby_id"], name: "index_tokens_on_furbaby_id"
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "messages", "tokens"
  add_foreign_key "tokens", "furbabies"
  add_foreign_key "tokens", "users"
end
