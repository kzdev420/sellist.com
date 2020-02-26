class RemoveProductFromSellerStore
  include Sidekiq::Worker

  def perform(item_id, seller_id)
    item = Item.find(item_id)
    seller = User.find(seller_id)

    product = Spree::Product.find(item.spree_id)
    seller_detail = seller.seller_detail
    store = Spree::Store.find(seller_detail.spree_id)
    product.stores -= [store] if product.stores.include? store
  end
end
