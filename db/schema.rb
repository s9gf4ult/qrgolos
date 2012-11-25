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

ActiveRecord::Schema.define(:version => 20121125050752) do

  create_table "anonymous", :force => true do |t|
    t.integer  "section_id"
    t.string   "aid"
    t.boolean  "fake"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "name"
    t.integer  "name_number"
  end

  add_index "anonymous", ["active"], :name => "index_anonymous_on_active"
  add_index "anonymous", ["aid"], :name => "index_anonymous_on_aid", :unique => true
  add_index "anonymous", ["fake"], :name => "index_anonymous_on_fake"
  add_index "anonymous", ["name"], :name => "index_anonymous_on_name"
  add_index "anonymous", ["name_number"], :name => "index_anonymous_on_name_number"
  add_index "anonymous", ["section_id"], :name => "index_anonymous_on_section_id"

  create_table "answer_variants", :force => true do |t|
    t.integer  "question_id"
    t.string   "text"
    t.integer  "position"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "answer_variants", ["position"], :name => "index_answer_variants_on_position"
  add_index "answer_variants", ["question_id"], :name => "index_answer_variants_on_question_id"
  add_index "answer_variants", ["text"], :name => "index_answer_variants_on_text"

  create_table "meetings", :force => true do |t|
    t.string   "name"
    t.text     "descr"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "questions", :force => true do |t|
    t.integer  "section_id"
    t.string   "question"
    t.string   "state"
    t.string   "kind"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.datetime "countdown_to"
  end

  create_table "screens", :force => true do |t|
    t.integer  "section_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sections", :force => true do |t|
    t.string   "name"
    t.integer  "meeting_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "descr"
  end

  create_table "twitts", :force => true do |t|
    t.integer  "anonymous_id"
    t.string   "state"
    t.text     "text"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
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
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "anonymous_id"
    t.integer  "answer_variant_id"
    t.integer  "vote"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "votes", ["anonymous_id"], :name => "index_votes_on_anonymous_id"
  add_index "votes", ["answer_variant_id"], :name => "index_votes_on_answer_variant_id"
  add_index "votes", ["vote"], :name => "index_votes_on_vote"

end
