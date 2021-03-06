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

ActiveRecord::Schema.define(:version => 20130326024902) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "patient_charges", :force => true do |t|
    t.integer  "amount"
    t.string   "liquidated"
    t.string   "description"
    t.datetime "date"
    t.integer  "patient_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.date     "session_date"
  end

  create_table "patient_payments", :force => true do |t|
    t.integer  "amount"
    t.datetime "date"
    t.integer  "patient_charge_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "patients", :force => true do |t|
    t.integer  "person_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "cost"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "plans", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "student_charges", :force => true do |t|
    t.integer  "amount"
    t.string   "liquidated"
    t.string   "description"
    t.datetime "date"
    t.integer  "student_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.boolean  "surcharge"
    t.integer  "original_amount"
  end

  create_table "student_payments", :force => true do |t|
    t.integer  "amount"
    t.datetime "date"
    t.integer  "student_charge_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "students", :force => true do |t|
    t.integer  "person_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "cost"
    t.integer  "plan_id"
  end

  create_table "user_sessions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "login"
    t.string   "persistence_token"
    t.string   "crypted_password"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

end
