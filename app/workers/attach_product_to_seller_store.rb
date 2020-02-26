class AttachProductToSellerStore
  include Sidekiq::Worker
  include SpreeSupport

  def perform(item_id, seller_id)
    item = Item.find(item_id)
    seller = User.find(seller_id)

    product = Spree::Product.find(item.spree_id)
    seller_detail = seller.seller_detail
    store = Spree::Store.find(seller_detail.spree_id)
    product.stores << store unless product.stores.include? store

    attach_store_taxons(store, seller, product, item)
  end
end
