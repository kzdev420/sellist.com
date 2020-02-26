class AddSpreeColsToCategoriesNItems < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :spree_id, :integer
    add_column :product_categories, :spree_id, :integer
    add_column :items, :spree_id, :integer
  end
end
