class Seller::ItemsController < Seller::MainController

  def index
    session[:catg_id] = ''
    session[:sub_catg_id] = ''
    session[:prod_catg_id] = ''
    seller_items = Item.joins(:seller_items).where("seller_id = ?", current_user.id)
    @seller_items = seller_items.where("discontinued = ?", false).paginate(page: params[:page], per_page: 10)
    #current_user.seller_items.where("discontinued = ?", false).paginate(page: params[:page], per_page: 10).map(&:item)
    @categories = seller_items.map(&:category).uniq.reject(&:blank?)
    @sub_categories = seller_items.map(&:sub_category_id).uniq
    @prod_categories = seller_items.map(&:product_category_id).uniq
    session[:discontinued] = false
  end

  def initiate_discontinue
    @seller_item = current_user.seller_items.find_by_item_id(params[:id])
  end

  def discontinued
    seller_item = current_user.seller_items.find(params[:id])
    seller_item.update_attributes(discontinued: true, discontinued_reason: params[:reason])
    ItemMailer.send_item_discontinued_notification_to_brand(seller_item.id).deliver
    #@seller_items = current_user.seller_items.where("discontinued = ?", false).paginate(page: params[:page], per_page: 10).map(&:item)
    @seller_items = Item.joins(:seller_items).where("seller_id = ? and discontinued = ?", current_user.id, false).paginate(page: params[:page], per_page: 10)
    flash[:notice] = "Item deleted from your store!"
  end

  def update_list
    session[:discontinued] = eval(params[:discontinued]) unless params[:discontinued].blank?
    session[:discontinued] ||= false
    params[:discontinued] = session[:discontinued]
    params[:seller_id] = current_user.id

    if params[:clear].to_s == "true"
      session[:catg_id] = ''
      session[:sub_catg_id] = ''
      session[:prod_catg_id] = ''
    else
      if !params[:prod_catg_id].blank?
        session[:catg_id] = ''
        session[:sub_catg_id] = ''
        session[:prod_catg_id] = ProductCategory.friendly.find(params[:prod_catg_id]).id
      elsif !params[:sub_catg_id].blank?
        session[:catg_id] = ''
        session[:sub_catg_id] = Category.friendly.find(params[:sub_catg_id]).id
        session[:prod_catg_id] = ''
      elsif !params[:catg_id].blank?
        session[:catg_id] = Category.friendly.find(params[:catg_id]).id
        session[:sub_catg_id] = ''
        session[:prod_catg_id] = ''
      end
    end

    search = Item.filter(params, session)
    @seller_items = search.result.page(params[:page]).per(10)
    #@seller_items = current_user.seller_items.where("discontinued = ?", params[:discontinued]).paginate(page: params[:page], per_page: 10)
  end
end
