class Brand::IntegrationsController < Brand::MainController
  include Brand::IntegrationsHelper
  skip_before_action :verify_authenticity_token, :only => [:sync, :save_items]

  def index
  end

  def sync
    brand = current_user.brand_detail
    if params[:commit] == "update"
      unless params[:old_products].blank?
        params[:old_products].each do |product_id|
          save_item(brand, product_id)
        end
        flash[:notice] = "Products updated successfully!"
      end
    else
      unless params[:new_products].blank?
        params[:new_products].each do |product_id|
          save_item(brand, product_id)
        end
        flash[:notice] = "Products created successfully!"
      end
    end
  end

  def save_items
    @products.each do |product|
      item = brand.items.find_or_create_by(item_number: product.id)
      attribs = product.variants[0]
      attributes = {}
      attributes['weight'] = attribs.weight
      attributes['weight_unit'] = attribs.weight_unit
      item.update(title: product.title, description: product.body_html, price: attribs.price, style: attributes.to_s)
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
  end
end
