class RemoveSpreeExtraCols < ActiveRecord::Migration[5.2]
  def change
    remove_column :categories, :spree_id
    remove_column :product_categories, :spree_id
    remove_column :brand_details, :spree_id
  end
end
