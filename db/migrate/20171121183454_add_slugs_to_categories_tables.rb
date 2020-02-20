class AddSlugsToCategoriesTables < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :slug, :string
    add_column :product_categories, :slug, :string
  end
end
