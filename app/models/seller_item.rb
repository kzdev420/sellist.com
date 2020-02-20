class SellerItem < ApplicationRecord
  belongs_to :seller, class_name: "User", foreign_key: :seller_id
  belongs_to :item, touch: true

  validates_uniqueness_of :item_id, scope: [:seller_id]

end
