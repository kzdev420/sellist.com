class AddProductToSpree
  include Sidekiq::Worker
  include SpreeSupport

  def perform(item_id)
    item = Item.find(item_id)
    shipping_category = Spree::ShippingCategory.last
    shipping_category = Spree::ShippingCategory.create(name: "default") if shipping_category.blank?

    unless item.sku.blank?
      if item.spree_id.blank?
        product = Spree::Product.create(name: item.display_name, description: item.description, meta_description: item.description, meta_keywords: item.meta_keywords, meta_title: item.display_name, shipping_category_id: shipping_category.id, price: item.price, sku: item.sku, available_on: (Time.now.utc-1.day))
        item.update(spree_id: product.id)
      else
        product = Spree::Product.find(item.spree_id)
        product.update(name: item.display_name, description: item.description, meta_description: item.description, meta_keywords: item.meta_keywords, meta_title: item.display_name, shipping_category_id: shipping_category.id, price: item.price, sku: item.sku)
      end

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

      item.images.each do |image|
        unless image.file.blank?
          img = product.images.new
          img.attachment = open(image.file.path)
          img.save
        end
      end

      item.seller_items.where("discontinued = ?", false).each do |seller_item|
        seller = seller_item.seller
        seller_detail = seller.seller_detail
        store = Spree::Store.find(seller_detail.spree_id)
        product.stores << store unless product.stores.include? store

        attach_store_taxons(store, seller, product, item)
      end
    end
  end
end
