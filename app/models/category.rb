class Category < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :parent, class_name: "Category", foreign_key: :parent_id, optional: true
  has_many :sub_categories, class_name: "Category", foreign_key: :parent_id, dependent: :destroy
  has_many :product_categories, class_name: "ProductCategory", foreign_key: :sub_category_id, dependent: :destroy
  has_many :items
  has_many :sub_items, class_name: "Item", foreign_key: :sub_category_id


  validates_presence_of :name

  rails_admin do
    create do
      include_all_fields
      field :parent_id, :enum do
        label 'category'
        enum_method do
          :parent_enum
        end
      end
      exclude_fields :parent, :sub_categories, :product_categories
    end

    update do
      include_all_fields
      field :parent_id, :enum do
        label 'category'
        enum_method do
          :parent_enum
        end
      end
      exclude_fields :parent
    end
  end

  def parent_enum
    Category.where("parent_id is null").map{|c| [c.name, c.id]}
  end

  def self.main
    joins(:items).where("parent_id is null and items.id is not null").distinct.order('name')
  end

end
