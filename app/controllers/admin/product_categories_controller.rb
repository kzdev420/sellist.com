class Admin::ProductCategoriesController < Admin::MainController

  def change_category
    #parent = Category.where("name ilike ?", params[:catg_id])[0]
    @categories = Category.where("parent_id = ?", params[:catg_id])
  end

  def upload_csv
    unless params[:csv_file].blank?
      csv = CSV.read(params[:csv_file].path, headers: true)
      header = csv.headers[0]
      data = csv[header]
      @names = csv[header].join(', ')
    end
  end

  def create
    if params[:csv_file].blank?
      ProductCategory.create(category_params)
      flash[:success] = "Product Category saved successfully!"
    else
      csv = CSV.read(params[:csv_file].path, headers: true)
      header = csv.headers[0]
      #csv.headers.each do |header|
        data = csv[header]
        data.each do |catg_name|
          catg = ProductCategory.new(category_params)
          catg.name = catg_name
          catg.save
        end
      #end
      flash[:success] = "File uploaded successfully!"
    end
  end

  def add
    unless params[:catg_id].blank? or params[:sub_catg_id2].blank?
      category = Category.find(params[:catg_id])
      sub_category = Category.find(params[:sub_catg_id2])
      unless params[:product_categories].blank?
        categories = params[:product_categories].split(',')
        categories.each do |catg|
          sub_category.product_categories.create(name: catg.squish, category_id: category.id)
        end
        flash[:success] = "Product Categories added successfully!"
      end
    else
      flash[:error] = "Please select Primary Category and Sub Category to add product categories under!"
    end
    redirect_to "/admin/categories?catg_id=#{params[:catg_id]}&sub_catg_id1=#{params[:sub_catg_id2]}"
  end

  def delete
    unless params[:del_product_categories].blank?
      params[:del_product_categories].each do |catg_id|
        category = ProductCategory.find(catg_id)
        category.destroy
      end
      flash[:success] = "Product-Categories deleted successfully!"
    else
      flash[:error] = "Please check atleast one checkbox under the box!"
    end
    redirect_to "/admin/categories?catg_id=#{params[:catg_id]}&sub_catg_id1=#{params[:sub_catg_id1]}"
  end

  private
  def category_params
    params.require(:product_category).permit(:name, :description, :category_id, :sub_category_id)
  end
end
