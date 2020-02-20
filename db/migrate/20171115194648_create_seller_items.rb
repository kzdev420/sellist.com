class CreateSellerItems < ActiveRecord::Migration[5.1]
  def change
    create_table :seller_items do |t|
      t.belongs_to :seller
      t.belongs_to :item
      t.boolean :discontinued, default: false
      t.text :discontinued_reason
      t.timestamps
    end
  end
end
