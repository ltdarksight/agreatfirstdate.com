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

ActiveRecord::Schema.define(:version => 20120317201349) do

  create_table "avatars", :force => true do |t|
    t.integer  "profile_id"
    t.string   "image"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.text     "bounds"
    t.string   "content_type", :default => "",  :null => false
    t.string   "file_size",    :default => "0", :null => false
  end

  create_table "event_descriptors", :force => true do |t|
    t.integer  "event_type_id"
    t.string   "name"
    t.string   "field_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "event_items", :force => true do |t|
    t.integer  "pillar_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "event_type_id"
    t.string   "string_1"
    t.string   "string_2"
    t.text     "text_1"
    t.text     "text_2"
    t.datetime "date_1"
    t.datetime "date_2"
    t.datetime "posted_at"
    t.string   "status",        :default => "active"
  end

  create_table "event_items_event_photos", :force => true do |t|
    t.integer  "event_item_id"
    t.integer  "event_photo_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "event_items_event_photos", ["event_item_id", "event_photo_id"], :name => "by_item_photo", :unique => true

  create_table "event_photos", :force => true do |t|
    t.string   "image"
    t.integer  "profile_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "event_types", :force => true do |t|
    t.integer  "pillar_category_id"
    t.string   "name"
    t.boolean  "has_attachments",    :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "favorites", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "favorite_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "inappropriate_contents", :force => true do |t|
    t.integer  "content_id"
    t.string   "content_type"
    t.text     "reason"
    t.string   "status",       :default => "active"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "pillar_categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "description", :default => ""
    t.string   "image"
  end

  create_table "pillars", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "pillar_category_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "points", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.text     "who_am_i",                     :default => "",       :null => false
    t.string   "first_name",                   :default => "",       :null => false
    t.string   "last_name",                    :default => "",       :null => false
    t.string   "gender"
    t.string   "looking_for"
    t.string   "in_or_around"
    t.string   "age"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
    t.string   "looking_for_age",              :default => ""
    t.integer  "points",                       :default => 100
    t.string   "avatar"
    t.text     "who_meet",                     :default => "",       :null => false
    t.text     "address",                      :default => ""
    t.string   "zip",                          :default => ""
    t.string   "card_number",                  :default => ""
    t.string   "card_type",                    :default => ""
    t.string   "card_expiration",              :default => ""
    t.string   "card_cvc",                     :default => ""
    t.date     "birthday"
    t.integer  "pillars_count",                :default => 0
    t.string   "status",                       :default => "active"
    t.string   "stripe_customer_token",        :default => ""
    t.boolean  "customer_status",              :default => false
    t.boolean  "customer_subscription_status", :default => false
    t.boolean  "invoice_status",               :default => false
  end

  create_table "search_caches", :force => true do |t|
    t.integer  "profile_id"
    t.string   "guest_hash"
    t.text     "pillar_ids"
    t.text     "result_ids"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "search_caches", ["guest_hash"], :name => "index_search_caches_on_guest_hash", :unique => true

  create_table "strikes", :force => true do |t|
    t.integer  "profile_id"
    t.integer  "striked_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",     :null => false
    t.string   "encrypted_password",     :default => "",     :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.datetime "deleted_at"
    t.string   "role",                   :default => "user"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
