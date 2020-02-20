class Seller::HomeController < Seller::MainController

  def dashboard
    @seller_items = current_user.seller_items.where("discontinued = ?", false)
  end
end
