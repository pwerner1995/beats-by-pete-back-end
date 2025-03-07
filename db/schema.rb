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

ActiveRecord::Schema.define(version: 2020_01_23_144735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "album_reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "album_id"
    t.float "rating"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "albums", force: :cascade do |t|
    t.string "title"
    t.string "cover"
    t.integer "artist_id"
    t.string "genre"
    t.integer "nb_tracks"
    t.string "label"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "artist_name"
    t.float "avg_rating"
    t.string "lg_cover"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "picture"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "avg_rating"
    t.string "lg_picture"
  end

  create_table "song_reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "song_id"
    t.float "rating"
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "songs", force: :cascade do |t|
    t.integer "album_id"
    t.integer "duration"
    t.string "preview"
    t.string "title"
    t.string "artist_name"
    t.string "album_cover"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "album_name"
    t.integer "avg_rating"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "avg_rating"
  end

end
