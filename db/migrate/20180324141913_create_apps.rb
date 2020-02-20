class CreateApps < ActiveRecord::Migration[5.1]
  def change
    create_table :apps do |t|
      t.string :name
      t.string :url
      t.string :logo
      t.boolean :original, default: true
      t.timestamps
    end
  end
end
