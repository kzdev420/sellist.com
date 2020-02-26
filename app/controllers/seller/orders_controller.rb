class Seller::OrdersController < Seller::MainController

  def index
    store = current_user.seller_detail
    spree_store = Spree::Store.find(store.spree_id)
    @orders = spree_store.orders
  end
end
