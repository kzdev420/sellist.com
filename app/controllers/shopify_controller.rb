class ShopifyController < ShopifyApp::AuthenticatedController
  layout 'user_home'

  def index
    #@products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    #@webhooks = ShopifyAPI::Webhook.find(:all)
    brand = current_user.brand_detail
    @products = ShopifyAPI::Product.find(:all)
    @new_products = []
    @old_products = []
    @products.each do |product|
      item = brand.items.find_by(item_number: product.id)
      if item.blank?
        @new_products << product
      else
        @old_products << product
      end
    end
    session[:products] = @products
  end

end
