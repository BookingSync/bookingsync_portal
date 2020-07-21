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

ActiveRecord::Schema.define(version: 2016_03_01_141356) do

  create_table "accounts", force: :cascade do |t|
    t.string "provider"
    t.integer "synced_id"
    t.string "name"
    t.string "oauth_access_token"
    t.string "oauth_refresh_token"
    t.datetime "oauth_expires_at"
    t.text "synced_data"
    t.datetime "synced_all_at"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "synced_source_id"
    t.index ["synced_id"], name: "index_accounts_on_synced_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "start_at"
    t.datetime "end_at"
    t.string "status"
  end

  create_table "connections", force: :cascade do |t|
    t.integer "remote_rental_id"
    t.integer "rental_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["remote_rental_id"], name: "index_connections_on_remote_rental_id"
    t.index ["rental_id"], name: "index_connections_on_rental_id"
  end

  create_table "photos", force: :cascade do |t|
    t.integer "rental_id"
    t.integer "synced_id"
    t.text "synced_data"
    t.datetime "synced_all_at"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rental_id"], name: "index_photos_on_rental_id"
    t.index ["synced_id"], name: "index_photos_on_synced_id"
  end

  create_table "rates", force: :cascade do |t|
    t.integer "rental_id"
    t.integer "synced_id"
    t.text "synced_data"
    t.datetime "synced_all_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rental_id"], name: "index_rates_on_rental_id"
    t.index ["synced_id"], name: "index_rates_on_synced_id"
  end

  create_table "remote_accounts", force: :cascade do |t|
    t.integer "account_id"
    t.integer "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_remote_accounts_on_account_id"
  end

  create_table "remote_rentals", force: :cascade do |t|
    t.integer "remote_account_id"
    t.integer "uid"
    t.text "remote_data"
    t.datetime "synchronized_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["remote_account_id"], name: "index_remote_rentals_on_remote_account_id"
  end

  create_table "rentals", force: :cascade do |t|
    t.integer "account_id"
    t.integer "synced_id"
    t.text "synced_data"
    t.datetime "synced_all_at"
    t.integer "position"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_rentals_on_account_id"
    t.index ["synced_id"], name: "index_rentals_on_synced_id"
  end

end
