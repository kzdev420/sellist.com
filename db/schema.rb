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

ActiveRecord::Schema.define(version: 20180404173518) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "logo"
    t.boolean "original", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "brand_details", force: :cascade do |t|
    t.bigint "user_id"
    t.string "company_name"
    t.string "ein"
    t.string "web_address"
    t.float "annual_revenue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_brand_details_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "images", force: :cascade do |t|
    t.integer "parent_id"
    t.string "parent_type"
    t.string "title"
    t.string "size"
    t.string "image_type"
    t.string "format"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "brand_detail_id"
    t.string "name"
    t.string "title"
    t.text "description"
    t.float "price"
    t.string "upc"
    t.string "item_number"
    t.string "model_number"
    t.float "discount_in_percent"
    t.float "discount_in_currency"
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.bigint "product_category_id"
    t.boolean "enabled_for_sale", default: false
    t.text "style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "heading_1"
    t.text "heading_2"
    t.text "heading_3"
    t.text "h1_description"
    t.text "h2_description"
    t.text "h3_description"
    t.float "commission_in_percent"
    t.float "commission_in_currency"
    t.integer "shopify_shop_id"
    t.string "sku"
    t.index ["brand_detail_id"], name: "index_items_on_brand_detail_id"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["product_category_id"], name: "index_items_on_product_category_id"
    t.index ["sub_category_id"], name: "index_items_on_sub_category_id"
  end

  create_table "product_categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id"
    t.bigint "sub_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["category_id"], name: "index_product_categories_on_category_id"
    t.index ["sub_category_id"], name: "index_product_categories_on_sub_category_id"
  end

  create_table "recommended_apps", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "url"
    t.boolean "integrated", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_recommended_apps_on_user_id"
  end

  create_table "seller_details", force: :cascade do |t|
    t.bigint "user_id"
    t.string "ssn_no"
    t.date "birth_date"
    t.string "store_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_seller_details_on_user_id"
  end

  create_table "seller_items", force: :cascade do |t|
    t.bigint "seller_id"
    t.bigint "item_id"
    t.boolean "discontinued", default: false
    t.text "discontinued_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_seller_items_on_item_id"
    t.index ["seller_id"], name: "index_seller_items_on_seller_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "shopify_shops", force: :cascade do |t|
    t.bigint "brand_detail_id"
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_detail_id"], name: "index_shopify_shops_on_brand_detail_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "suit"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.string "account_type"
    t.boolean "is_admin", default: false
    t.boolean "active", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_super_admin", default: false
    t.string "phone"
    t.string "profile_pic"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
