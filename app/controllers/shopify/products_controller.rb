class Shopify::ProductsController < Shopify::MainController
  include Shopify::ProductsHelper

  def update_list
    unless params[:id].blank?
      brand = current_user.brand_detail
      @shopify_shop = brand.shopify_shops.find_by(id: params[:id])
      shop = Shop.find_by_shopify_domain(@shopify_shop.url)
      unless shop.blank?
        shop_session = ShopifyAPI::Session.new(shop.shopify_domain, shop.shopify_token)
        ShopifyAPI::Base.activate_session(shop_session)
        begin
          @products = ShopifyAPI::Product.find(:all)
          session[:products] = @products
          @old_products = @products.select{|p| @shopify_shop.items.find_by(item_number: p.id).present?}
        rescue Exception => ex
          puts ex
        end
      else
        flash[:error] = "Invalid Shop ID"
      end
    else
      flash[:error] = "Please provide shopify domain ID"
    end
  end

  def sync
    brand = current_user.brand_detail
    @shopify_shop = brand.shopify_shops.find_by(id: params[:shopify_shop_id])
    if params[:commit] == "update"
      unless params[:old_products].blank?
        params[:old_products].each do |product_id|
          save_item(brand, product_id, params[:shopify_shop_id])
        end
        flash[:notice] = "Products updated successfully!"
      end
    else
      unless params[:products].blank?
        ShopifyProductsWorker.perform_async(brand.id, params[:shopify_shop_id], params[:products], session[:products].to_json)
        #params[:products].each do |product_id|
          #save_item(brand, product_id, params[:shopify_shop_id])
        #end
        delete_ids = session[:products].map(&:id).map(&:to_s) - params[:products]
        delete_ids.each do |product_id|
          delete_item(brand, product_id, params[:shopify_shop_id])
        end
        flash[:notice] = "Products will be created soon!"
      end
    end
  end

  def sync_product
    brand = current_user.brand_detail
    @shopify_shop = brand.shopify_shops.find_by(id: params[:shopify_shop_id])
    item = @shopify_shop.items.find_by(item_number: params[:id])
    if item.present?
      item.destroy
    else
      save_item(brand,  params[:id], params[:shopify_shop_id])
    end
    render json: {message: "Done"}
  end

  def delete
    brand = current_user.brand_detail
    @shopify_shop = brand.shopify_shops.find_by(id: params[:shopify_shop_id])
    unless params[:old_products].blank?
      params[:old_products].each do |product_id|
        delete_item(brand, product_id, params[:shopify_shop_id])
      end
      flash[:notice] = "Products deleted successfully!"
    end
    redirect_to brand_items_path
  end
end
