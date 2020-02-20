class AddAppInstalledToShopifyShop < ActiveRecord::Migration[5.1]
  def change
    add_column :shopify_shops, :app_installed, :boolean, default: true
  end
end
