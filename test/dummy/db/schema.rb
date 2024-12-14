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

ActiveRecord::Schema[7.1].define(version: 2024_12_14_103907) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "billing_invoice_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "billing_invoice_id", null: false
    t.datetime "date"
    t.integer "duration"
    t.integer "kind"
    t.decimal "unit_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_invoice_id"], name: "index_billing_invoice_items_on_billing_invoice_id"
  end

  create_table "billing_invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "issue_date", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "status"
    t.integer "number", null: false
    t.bigint "billing_issuer_id", null: false
    t.bigint "billing_recipient_id", null: false
    t.decimal "net_total", default: "0.0"
    t.integer "tax_rate", default: 0
    t.decimal "tax_amount", default: "0.0"
    t.decimal "gross_total", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["billing_issuer_id"], name: "index_billing_invoices_on_billing_issuer_id"
    t.index ["billing_recipient_id"], name: "index_billing_invoices_on_billing_recipient_id"
  end

  create_table "billing_issuers", force: :cascade do |t|
    t.string "name"
    t.string "tax_number"
    t.string "email"
    t.string "address"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "billing_recipients", force: :cascade do |t|
    t.string "name"
    t.string "tax_number"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "billing_invoice_items", "billing_invoices"
  add_foreign_key "billing_invoices", "billing_issuers"
  add_foreign_key "billing_invoices", "billing_recipients"
end
