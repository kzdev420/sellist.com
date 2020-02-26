class SellerItem < ApplicationRecord
  belongs_to :seller, class_name: "User", foreign_key: :seller_id
  belongs_to :item, touch: true

  validates_uniqueness_of :item_id, scope: [:seller_id]

  after_commit :update_product_to_store, if: -> { !item.spree_id.blank? and item.enabled_for_sale }

  def update_product_to_store
    if !discontinued and (saved_change_to_id? or saved_change_to_discontinued?)
      AttachProductToSellerStore.perform_async(self.item_id, self.seller_id)
    elsif discontinued and saved_change_to_discontinued?
      RemoveProductFromSellerStore.perform_async(self.item_id, self.seller_id)
    end
  end
end
