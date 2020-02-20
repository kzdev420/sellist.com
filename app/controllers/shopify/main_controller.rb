class Shopify::MainController < ApplicationController
  layout 'user_home'
  before_action :authenticate_user!

  def index
    brand = current_user.brand_detail
    @shopify_shops = brand.shopify_shops.order(:updated_at)
    if @shopify_shops.blank?
      params[:step] = 1
    else
      params[:step] = 3
      @shopify_shop = @shopify_shops.last
      shop = Shop.find_by_shopify_domain(@shopify_shop.url)
      unless shop.blank?
        shop_session = ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
        ShopifyAPI::Base.activate_session(shop_session)
        begin
          @products = ShopifyAPI::Product.find(:all)
          session[:products] = @products
          @old_products = @products.select{|p| @shopify_shop.items.find_by(item_number: p.id).present?}
        rescue Exception => ex
          puts ex
        end
      else
        flash[:error] = "Invalid Shop ID"
      end
    end
  end
end
