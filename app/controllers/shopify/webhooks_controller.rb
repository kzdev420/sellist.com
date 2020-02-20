class Shopify::WebhooksController < Shopify::MainController
  include ShopifyApp::WebhookVerification

  def receive
    params.permit!
    if params[:type].incluce? "products"
      ProductsUpdateJob.perform_later(shop_domain: shop_domain, webhook: webhook_params.to_h)
    elsif params[:type].incluce? "app_uninstalled"
      shopify_shop = ShopifyShop.find_by(url: shop_domain)
      shopify_shop.update(app_installed: false)
    end
    head :no_content
  end

  private

  def webhook_params
    params.except(:controller, :action, :type)
  end
end
