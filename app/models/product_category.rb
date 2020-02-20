class ProductCategory < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :category
  belongs_to :sub_category, class_name: "Category", foreign_key: :sub_category_id
  has_many :items

  validates_presence_of :name, :category_id, :sub_category_id

  rails_admin do
    include_all_fields
    field :name do
      label 'Product Category'
    end

    create do
      include_all_fields
      exclude_fields :category, :sub_category
      field :name do
        label 'Product Category'
        def render
          bindings[:view].render partial: "bulk_categories"
        end
      end
      field :category_id, :enum do
        enum_method do
          :category_enum
        end
      end
      field :sub_category_id do
        def render
          bindings[:view].render partial: "sub_categories"
        end
      end
    end

    update do
      include_all_fields
      exclude_fields :category, :sub_category
      field :name do
        label 'Product Category'
      end
      field :category_id, :enum do
        enum_method do
          :category_enum
        end
      end
      field :sub_category_id do
        def render
          bindings[:view].render partial: "sub_categories"
        end
      end
    end
  end

  def category_enum
    Category.where("parent_id is null").map{|c| [c.name, c.id]}
  end
end
