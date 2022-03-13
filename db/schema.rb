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

ActiveRecord::Schema.define(version: 2022_03_13_144653) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "confirmed_phone_numbers", force: :cascade do |t|
    t.string "phone_no"
    t.integer "user_id"
    t.integer "pin_typing_attempts", default: 0, null: false
    t.integer "pin_sendings", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["phone_no"], name: "index_confirmed_phone_numbers_on_phone_no", unique: true
  end

  create_table "hosts", force: :cascade do |t|
    t.integer "user_id"
    t.text "address"
    t.string "postal_code", limit: 20
    t.string "city", limit: 50
    t.string "country", limit: 2
    t.integer "optimal_no_guests"
    t.integer "max_sleeps"
    t.integer "max_duration"
    t.string "sleep_conditions"
    t.string "which_guests"
    t.string "which_hosts"
    t.text "description"
    t.string "languages"
    t.text "other_comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "available", default: true
    t.string "guest_name"
    t.string "guest_data"
    t.string "pickup_data"
    t.date "guest_end_date"
    t.index ["available"], name: "index_hosts_on_available"
  end

  create_table "user_privileges", force: :cascade do |t|
    t.string "privilege"
    t.string "scope"
    t.integer "user_id"
    t.index ["user_id"], name: "index_user_privileges_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "personal_name", limit: 100
    t.string "family_name", limit: 100
    t.string "mobile", limit: 50
    t.boolean "is_matcher"
    t.boolean "is_host"
    t.boolean "is_refugee"
    t.string "languages"
    t.text "social_links"
    t.string "gender", limit: 1
    t.text "address"
    t.string "postal_code", limit: 20
    t.string "city", limit: 100
    t.string "country", limit: 2
    t.integer "verified_phone"
    t.integer "verified_passport"
    t.integer "verified_in_person"
    t.integer "verified_address"
    t.integer "trustworthiness"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "id_or_passport_no", limit: 20
    t.string "contact_time"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
