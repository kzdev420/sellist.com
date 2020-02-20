class CreateRecommendedApps < ActiveRecord::Migration[5.1]
  def change
    create_table :recommended_apps do |t|
      t.belongs_to :user
      t.string :name
      t.string :url
      t.boolean :integrated, default: false
      t.timestamps
    end
  end
end
