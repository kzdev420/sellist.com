class Admin::CategoriesController < Admin::MainController
  include ActionView::Helpers::TextHelper
  include RailsAdmin::MainHelper
  include RailsAdmin::ApplicationHelper
  include RailsAdmin::Engine.routes.url_helpers

  def index
    action = RailsAdmin::Config::Actions.find('index'.to_sym)
    @page_name = "Categories"
    @authorization_adapter.try(:authorize, action.authorization_key, @abstract_model, @object)
    @action = action.with({controller: self, abstract_model: @abstract_model, object: @object})
    @categories = Category.where("parent_id is null")
    if params[:id].present?
      @category = Category.find(params[:id])
      @sub_categories = @category.sub_categories
    elsif params[:catg_id].present? and params[:sub_catg_id1].present?
      @category = Category.find(params[:catg_id])
      @sub_categories = @category.sub_categories
      @sub_category = Category.find(params[:sub_catg_id1])
      @product_categories = @sub_category.product_categories
      params[:type] = "sub_catg_options1"
    else
      @sub_categories = @categories[0].sub_categories
    end
  end

  def change_category
    unless params[:id].blank?
      @category = Category.find(params[:id])
      @sub_categories = @category.sub_categories
    end
  end

  def add
    unless params[:categories].blank?
      categories = params[:categories].split(',')
      categories.each do |catg|
        Category.create(name: catg.squish)
      end
      flash[:success] = "Categories added successfully!"
    end
    redirect_to '/admin/categories'
  end

  def delete
    unless params[:del_categories].blank?
      params[:del_categories].each do |catg_id|
        category = Category.find(catg_id)
        category.destroy
      end
      flash[:success] = "Categories deleted successfully!"
    else
      flash[:error] = "Please check atleast one checkbox under the box!"
    end
    redirect_to '/admin/categories'
  end
end
