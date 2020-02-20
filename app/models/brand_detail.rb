class BrandDetail < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :shopify_shops

  searchable do
    text :company_name
    time    :created_at
  end
end
