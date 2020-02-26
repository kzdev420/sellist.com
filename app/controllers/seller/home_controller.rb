class Seller::HomeController < Seller::MainController

  def dashboard
    @seller_items = current_user.seller_items.where("discontinued = ?", false)
  end

  def store
    store = current_user.seller_detail
    spree_store = Spree::Store.find(store.spree_id)
    redirect_to "http://#{spree_store.url}"
  end
end
