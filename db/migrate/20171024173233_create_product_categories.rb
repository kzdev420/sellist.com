class CreateProductCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.text :description
      t.belongs_to :category
      t.belongs_to :sub_category
      t.timestamps
    end
  end
end
