class RemoveProductFromSpree
  include Sidekiq::Worker

  def perform(item_id)
    item = Item.find(item_id)

    product = Spree::Product.find(item.spree_id)
    product.destroy
  end
end
