module Shopify::ProductsHelper

  def save_item(brand, product_id, shopify_shop_id)
    #product = ''
    #session[:products].map{|p| product = p if p.id.to_s == product_id.to_s}
    product = session[:products].select{|p| p.id.to_s == product_id.to_s}[0]
    item = @shopify_shop.items.find_or_create_by(item_number: product_id)
    attribs = product.variants[0]
    attributes = {}
    attributes['weight'] = attribs.weight
    attributes['weight_unit'] = attribs.weight_unit
    item.update(title: product.title, description: product.body_html, price: attribs.price, style: attributes.to_s, brand_detail_id: brand.id, sku: attribs.sku)
    item.images.destroy_all
    product.images.each do |img|
      name = img.src.split('/').last.split('?').first
      image = item.images.create(remote_file_url: img.src, size: "#{img.width}X#{img.height}", image_type: MIME::Types.type_for(name)[0].to_s, title: name, format: name.split('.').last)
      #image.file = URI.parse(img.src)
      #image.file = open(img.src) if image.file.url.blank?
      #image.remote_file_url = img.src
      #image.save
    end
  end

  def delete_item(brand, product_id, shopify_shop_id)
    #product = ''
    #session[:products].map{|p| product = p if p.id.to_s == product_id.to_s}
    # product = session[:products].select{|p| p.id.to_s == product_id.to_s}[0]
    item = @shopify_shop.items.find_by(item_number: product_id)
    item.destroy unless item.blank?
  end
end
