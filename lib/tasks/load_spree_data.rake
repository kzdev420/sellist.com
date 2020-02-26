desc "Fetching Public Sensors Data"

namespace :load_spree_data do
  task :users => :environment do

    users = User.where("is_super_admin is false")
    users.each do |user|
      if user.brand
        brand_role = Spree::Role.where(name: 'manufacturer').first
        unless user.spree_roles.include? brand_role
          user.spree_roles << brand_role
        end
      elsif user.seller
        store_role = Spree::Role.where(name: 'store').first
        seller_role = Spree::Role.where(name: 'seller').first
        unless user.spree_roles.include? store_role
          user.spree_roles << store_role
        end
        unless user.spree_roles.include? seller_role
          user.spree_roles << seller_role
        end
      end
    end
  end

  task :stores => :environment do

    users = User.where("account_type = ?", "seller")
    users.each do |user|
      seller = user.seller_detail
      unless seller.blank? or seller.store_name.blank?
        slug = seller.store_name.downcase.gsub(' ', '')
        store = Spree::Store.find_or_create_by(url: "#{slug}.#{APP_CONFIG['site_domain']}")
        store.update(name: seller.store_name, mail_from_address: user.email, default_currency: '', code: slug)

        seller.update(spree_id: store.id)
      end
    end
  end

  task :option_types => :environment do

    option_type = Spree::OptionType.find_or_create_by(name: "size")
    option_type.update(presentation: "Size")

    option_type = Spree::OptionType.find_or_create_by(name: "color")
    option_type.update(presentation: "Color")
  end

  task :products => :environment do
    shipping_category = Spree::ShippingCategory.last
    shipping_category = Spree::ShippingCategory.create(name: "default") if shipping_category.blank?
    items = Item.where(enabled_for_sale: true)
    items.each do |item|
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

  def attach_store_taxons(store, seller, product, item)
    # Attach Brand Taxon
    brand_taxonomy = store.taxonomies.find_or_create_by(name: "Brands")
    main_taxon = brand_taxonomy.taxons.find_by(name: brand_taxonomy.name)

    brand = item.brand_detail
    taxon = brand_taxonomy.taxons.find_by(name: brand.company_name)
    if taxon.blank?
      main_permalink = main_taxon.permalink
      taxon = brand_taxonomy.taxons.create(name: brand.company_name)
      taxon.move_to(main_taxon.id, :child)
      taxon.update(permalink: "#{main_permalink}/#{taxon.permalink}") unless taxon.permalink.include? main_permalink
    end
    product.taxons << taxon unless taxon.blank? or product.taxons.include? taxon


    # Attach Category Taxon
    catg_taxonomy = store.taxonomies.find_or_create_by(name: "Categories")
    main_taxon = catg_taxonomy.taxons.find_by(name: catg_taxonomy.name)

    if !item.product_category_id.blank?
      product_catg = item.product_category

      catg = product_catg.category
      catg_taxon = get_n_save_catg_taxon(catg, catg_taxonomy, main_taxon)

      sub_catg = product_catg.sub_category
      sub_catg_taxon = get_n_save_sub_catg_taxon(sub_catg, catg_taxonomy, catg_taxon)

      product_catg_taxon = get_n_save_prod_catg_taxon(product_catg, catg_taxonomy, sub_catg_taxon)

      product.taxons << product_catg_taxon unless product_catg_taxon.blank? or product.taxons.include? product_catg_taxon
    elsif !item.sub_category_id.blank?
      sub_catg = item.sub_category

      catg = sub_catg.parent
      catg_taxon = get_n_save_catg_taxon(catg, catg_taxonomy, main_taxon)

      sub_catg_taxon = get_n_save_sub_catg_taxon(sub_catg, catg_taxonomy, catg_taxon)

      product.taxons << sub_catg_taxon unless sub_catg_taxon.blank? or product.taxons.include? sub_catg_taxon
    elsif !item.category_id.blank?
      catg = item.category
      catg_taxon = get_n_save_catg_taxon(catg, catg_taxonomy, main_taxon)
      product.taxons << catg_taxon unless catg_taxon.blank? or product.taxons.include? catg_taxon
    end
  end

  def get_n_save_catg_taxon(catg, catg_taxonomy, main_taxon)
    catg_taxon = catg_taxonomy.taxons.find_by(name: catg.name)
    if catg_taxon.blank?
      main_permalink = main_taxon.permalink

      catg_taxon = catg_taxonomy.taxons.create(name: catg.name)
      catg_taxon.move_to(main_taxon.id, :child)
      catg_taxon.update(permalink: "#{main_permalink}/#{catg_taxon.permalink}") unless catg_taxon.permalink.include? main_permalink
    end
    return catg_taxon
  end

  def get_n_save_sub_catg_taxon(sub_catg, catg_taxonomy, catg_taxon)
    sub_catg_taxon = catg_taxon.children.find_by(name: sub_catg.name)
    if sub_catg_taxon.blank?
      sub_catg_taxon = catg_taxonomy.taxons.create(name: sub_catg.name, parent_id: catg_taxon.id)
      sub_catg_taxon.move_to(catg_taxon.id, :child)
    end
    return sub_catg_taxon
  end

  def get_n_save_prod_catg_taxon(product_catg, catg_taxonomy, sub_catg_taxon)
    product_catg_taxon = sub_catg_taxon.children.find_by(name: product_catg.name)
    if product_catg_taxon.blank?
      product_catg_taxon = catg_taxonomy.taxons.create(name: product_catg.name, parent_id: sub_catg_taxon.id)
      product_catg_taxon.move_to(sub_catg_taxon.id, :child)
    end
    return product_catg_taxon
  end
end
