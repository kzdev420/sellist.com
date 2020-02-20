class CreateBrandDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :brand_details do |t|
      t.belongs_to :user
      t.string :company_name
      t.string :ein
      t.string :web_address
      t.float :annual_revenue
      t.timestamps
    end
  end
end
