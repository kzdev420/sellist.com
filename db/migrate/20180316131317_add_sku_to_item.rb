class AddSkuToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :sku, :string
  end
end
