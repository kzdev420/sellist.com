class Shopify::IntegrationsController < ShopifyApp::AuthenticatedController
  layout 'user_home'

  def index
    #@products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    #@webhooks = ShopifyAPI::Webhook.find(:all)
    brand = current_user.brand_detail
    shop_url = shop_session.url
    @token = ShopifyAPI::Base.activate_session(shop_session)
    @shopify_shop = brand.shopify_shops.find_or_create_by(url: shop_url)
    @shopify_shop.update(updated_at: Time.now, name: shop_url.split('.').first)
    @products = ShopifyAPI::Product.find(:all)
    @old_products = @products.select{|p| @shopify_shop.items.find_by(item_number: p.id).present?}
    session[:products] = @products
    params[:step] = 3
    @shopify_shops = brand.shopify_shops
  end
end
