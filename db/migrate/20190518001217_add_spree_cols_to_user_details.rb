class AddSpreeColsToUserDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :brand_details, :spree_id, :integer
    add_column :seller_details, :spree_id, :integer
  end
end
