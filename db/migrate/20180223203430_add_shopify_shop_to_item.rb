class AddShopifyShopToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :shopify_shop_id, :integer
  end
end
