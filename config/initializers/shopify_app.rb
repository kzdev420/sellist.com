ShopifyApp.configure do |config|
  config.application_name = APP_CONFIG['shopify_app_name']
  config.api_key = APP_CONFIG['shopify_app_key']
  config.secret = APP_CONFIG['shopify_app_secret']
  config.scope = "read_orders, read_products, write_products, read_customers"
  config.embedded_app = true
  config.after_authenticate_job = false
  #config.session_repository = ShopifyApp::InMemorySessionStore
  config.session_repository = Shop
  config.root_url = '/shopify'

  # Webhooks Initialization
  config.webhooks = [
    {topic: 'shop/update', address: "#{APP_CONFIG['site_url']}/shopify/webhooks/shop_update", format: 'json'},
    {topic: 'products/create', address: "#{APP_CONFIG['site_url']}/shopify/webhooks/products_create", format: 'json'},
    {topic: 'products/update', address: "#{APP_CONFIG['site_url']}/shopify/webhooks/products_update", format: 'json'},
    {topic: 'products/delete', address: "#{APP_CONFIG['site_url']}/shopify/webhooks/products_delete", format: 'json'},
    {topic: 'carts/update', address: "#{APP_CONFIG['site_url']}/shopify/webhooks/carts_update", format: 'json'},
    {topic: 'app/uninstalled', address: "#{APP_CONFIG['site_url']}/shopify/webhooks/app_uninstalled", format: 'json'}
  ]
  #config.after_authenticate_job = { job: Shopify::AfterAuthenticateJob, inline: false }
end
