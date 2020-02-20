class CreateShopifyShops < ActiveRecord::Migration[5.1]
  def change
    create_table :shopify_shops do |t|
      t.belongs_to :brand_detail
      t.string :name
      t.string :url
      t.timestamps
    end
  end
end
