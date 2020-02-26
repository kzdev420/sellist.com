module SpreeSupport

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
