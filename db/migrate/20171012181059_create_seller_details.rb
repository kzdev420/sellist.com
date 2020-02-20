class CreateSellerDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :seller_details do |t|
      t.belongs_to :user
      t.string :ssn_no
      t.date :birth_date
      t.string :store_name
      t.timestamps
    end
  end
end
