class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.integer :parent_id
      t.string :parent_type
      t.string :title
      t.string :file
      t.string :size
      t.string :image_type
      t.string :format

      t.timestamps
    end
  end
end
