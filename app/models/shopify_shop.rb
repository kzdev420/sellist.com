class ShopifyShop < ApplicationRecord
  belongs_to :brand_detail, optional: true
  has_many :items
end
