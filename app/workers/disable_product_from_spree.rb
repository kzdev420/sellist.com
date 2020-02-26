class DisableProductFromSpree
  include Sidekiq::Worker

  def perform(item_id)
    item = Item.find(item_id)

    product = Spree::Product.find(item.spree_id)
    product.update(available_on: nil)
  end
end
