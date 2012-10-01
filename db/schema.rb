# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120828060225) do

  create_table "admins", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "answers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
    t.text     "answer"
    t.boolean  "true"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"

  create_table "puzzles", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "paid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sound_file_name"
    t.string   "sound_content_type"
    t.integer  "sound_file_size"
    t.datetime "sound_updated_at"
  end

  create_table "questions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "puzzle_id"
    t.string   "word"
    t.integer  "q_number"
    t.string   "part_of_speech"
    t.string   "example_sentence"
    t.string   "root"
    t.string   "root_language"
    t.string   "etymology_meaning"
    t.string   "actual_definition"
  end

  add_index "questions", ["puzzle_id"], :name => "index_questions_on_puzzle_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "settings", :force => true do |t|
    t.string   "default_language"
    t.string   "site_title"
    t.text     "welcome_text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_details", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_answer"
    t.string   "email"
    t.string   "mbti_result"
    t.string   "device_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_puzzles", :force => true do |t|
    t.string   "device_id"
    t.integer  "puzzle_id"
    t.string   "score"
    t.string   "correct_answer"
    t.string   "wronge_answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "question_detail", :limit => 2147483647
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "deviceId"
    t.string   "device_name"
    t.boolean  "paid"
  end

  create_table "users_profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.integer  "mbti_score_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
