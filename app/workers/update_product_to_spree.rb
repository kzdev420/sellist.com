class UpdateProductToSpree
  include Sidekiq::Worker

  def perform(item_id)
    item = Item.find(item_id)

    product = Spree::Product.find(item.spree_id)
    product.update(name: item.display_name, description: item.description, meta_description: item.description, meta_keywords: item.meta_keywords, meta_title: item.display_name, price: item.price, sku: item.sku)

    style = (item.style.blank? ? '' : eval(item.style))
    unless style.blank?
      style.each do |name, value|
        value = value.reject(&:blank?) if value.class == Array
        if ["height", "weight"].include? name.downcase
          product.send("#{name.downcase}=",value)
        else
          option_type = Spree::OptionType.where("name ilike ? or presentation ilike ?", name, name)[0]
          if option_type.present?
            product.option_types << option_type
          end
          if value.class == Array
            product.set_property(name, value.join(', '))
          else
            product.set_property(name, value)
          end
        end
      end
    end

    item.images.destroy_all
    item.images.each do |image|
      unless image.file.blank?
        img = product.images.new
        img.attachment = open(image.file.path)
        img.save
      end
    end
  end
end
