class ShopifyProductsWorker
  include Sidekiq::Worker

  def perform(brand_id, shopify_shop_id, products, session_products)
    brand = BrandDetail.find(brand_id)
    shopify_shop = brand.shopify_shops.find_by(id: shopify_shop_id)

    selected_products = []
    session_products = eval(session_products.gsub("null", "nil"))
    session_products = session_products.map{|p| p.stringify_keys}
    session_products.map{|p| selected_products << p if products.include? p["id"].to_s}

    selected_products.each do |product|
      item = shopify_shop.items.find_or_create_by(item_number: product["id"])
      attribs = product["variants"][0]
      attribs = attribs.stringify_keys
      attributes = {}
      attributes['weight'] = attribs["weight"]
      attributes['weight_unit'] = attribs["weight_unit"]
      desc = ActionView::Base.full_sanitizer.sanitize(product["body_html"])
      item.update(title: product["title"], description: desc, price: attribs["price"], style: attributes.to_s, brand_detail_id: brand.id, sku: attribs["sku"])
      item.images.destroy_all
      product["images"].each do |img|
        img = img.stringify_keys
        src = img["src"]
        name = src.split('/').last.split('?').first
        image = item.images.create(remote_file_url: src, size: "#{img['width']}X#{img['height']}", image_type: MIME::Types.type_for(name)[0].to_s, title: name, format: name.split('.').last)
      end
    end
    Item.index
  end
end
