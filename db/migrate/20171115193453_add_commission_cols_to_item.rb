class AddCommissionColsToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :commission_in_percent, :float
    add_column :items, :commission_in_currency, :float
  end
end
