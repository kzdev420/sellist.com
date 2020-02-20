class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.belongs_to :brand_detail
      t.string :name
      t.string :title
      t.text :description
      t.float :price
      t.string :upc
      t.string :item_number
      t.string :model_number
      t.text :heading_1
      t.text :heading_2
      t.text :heading_3
      t.text :h1_description
      t.text :h2_description
      t.text :h3_description
      t.float :discount_in_percent
      t.float :discount_in_currency
      t.belongs_to :category
      t.belongs_to :sub_category
      t.belongs_to :product_category
      t.boolean :enabled_for_sale, default: false
      t.text :style

      t.timestamps
    end
  end
end
