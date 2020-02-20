class Admin::SubCategoriesController < Admin::MainController

  def change_main_category
    unless params[:catg_id].blank?
      @category = Category.find(params[:catg_id])
      @sub_categories = @category.sub_categories
    end
    # @num = params[:type].gsub('sub_catg_options', '')
  end

  def change_sub_category
    unless params[:sub_catg_id1].blank?
      @sub_category = Category.find(params[:sub_catg_id1])
      @product_categories = @sub_category.product_categories
      @product_categories = [] if @product_categories.blank?
    end
  end

  def add
    unless params[:category_id].blank?
      category = Category.find(params[:category_id])
      unless params[:sub_categories].blank?
        categories = params[:sub_categories].split(',')
        categories.each do |catg|
          category.sub_categories.create(name: catg.squish)
        end
        flash[:success] = "Sub Categories added successfully!"
      end
    else
      flash[:error] = "Please select Primary Category to add sub categories under!"
    end
    redirect_to "/admin/categories?id=#{params[:category_id]}"
  end

  def delete
    unless params[:del_sub_categories].blank?
      params[:del_sub_categories].each do |catg_id|
        category = Category.find(catg_id)
        category.destroy
      end
      flash[:success] = "Sub-Categories deleted successfully!"
    else
      flash[:error] = "Please check atleast one checkbox under the box!"
    end
    redirect_to "/admin/categories?id=#{params[:id]}"
  end
end
