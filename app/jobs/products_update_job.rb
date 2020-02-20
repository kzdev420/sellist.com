class ProductsUpdateJob < ApplicationJob
  def perform(shop_domain:, webhook:)
    shop = Shop.find_by(shopify_domain: shop_domain)

    shop.with_shopify_session do
      vendor = webhook["vendor"]
      shopify_shop = ShopifyShop.find_by(url: shop_domain)
      shopify_shop.update(name: vendor)
      brand = shopify_shop.brand_detail
      product_id = webhook["id"]
      item = shopify_shop.items.find_or_create_by(item_number: product_id)
      unless item.blank?
        attribs = webhook["variants"][0]
        attributes = {}
        attributes['weight'] = attribs["weight"]
        attributes['weight_unit'] = attribs["weight_unit"]
        item.update(title: webhook["title"], description: webhook["body_html"], price: attribs["price"], style: attributes.to_s, brand_detail_id: brand.id)
        item.images.destroy_all
        webhook["images"].each do |img|
          name = img["src"].split('/').last.split('?').first
          image = item.images.create(remote_file_url: img["src"], size: "#{img['width']}X#{img['height']}", image_type: MIME::Types.type_for(name)[0].to_s, title: name, format: name.split('.').last)
          #image.file = URI.parse(img.src)
          #image.file = open(img.src) if image.file.url.blank?
          #image.remote_file_url = img.src
          #image.save
        end
      end
    end
  end
end
