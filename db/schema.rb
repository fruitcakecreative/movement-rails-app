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

ActiveRecord::Schema[7.2].define(version: 2025_04_05_022743) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.bigint "genre_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ra_followers"
    t.index ["genre_id"], name: "index_artists_on_genre_id"
  end

  create_table "artists_events", id: false, force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "event_id", null: false
    t.index ["artist_id", "event_id"], name: "index_artists_events_on_artist_id_and_event_id"
    t.index ["event_id", "artist_id"], name: "index_artists_events_on_event_id_and_artist_id"
  end

  create_table "event_attendees", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_attendees_on_event_id"
    t.index ["user_id"], name: "index_event_attendees_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.datetime "date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "venue_id", null: false
    t.string "source"
    t.text "description"
    t.string "event_url"
    t.integer "attending_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ticket_url"
    t.decimal "ticket_price", precision: 8, scale: 2
    t.string "ticket_tier"
    t.string "ticket_wave"
    t.string "font_color"
    t.boolean "manual_override"
    t.string "short_title"
    t.string "event_logo"
    t.string "even_shorter_title"
    t.boolean "free_event"
    t.boolean "food_available"
    t.string "indoor_outdoor"
    t.string "age"
    t.string "promoter"
    t.text "notes"
    t.string "bg_color"
    t.boolean "manual_override_ticket", default: false
    t.boolean "manual_override_location", default: false
    t.boolean "manual_override_times", default: false
    t.boolean "manual_override_genres", default: false
    t.boolean "manual_override_title"
    t.boolean "manual_override_artists"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "events_genres", id: false, force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "genre_id", null: false
    t.index ["event_id"], name: "index_events_genres_on_event_id"
    t.index ["genre_id"], name: "index_events_genres_on_genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "hex_color"
    t.string "short_name"
    t.string "font_color"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "profile_info"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "venues", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_filename"
    t.string "hex_color"
    t.string "font_color"
    t.string "subheading"
    t.string "venue_type"
    t.string "serves_alcohol"
    t.text "notes"
  end

  add_foreign_key "artists", "genres"
  add_foreign_key "event_attendees", "events"
  add_foreign_key "event_attendees", "users"
  add_foreign_key "events", "venues"
end
