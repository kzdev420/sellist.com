class Brand::ItemsController < Brand::MainController
  include Brand::ItemsHelper

  def upload_item
    unless params[:item_file].blank?
      path = params[:item_file].path
      get_file_content(path)
      unless @csv.blank?
        save_file_temporarily(params[:item_file])
        @categories = Category.where("parent_id is null")
        @sub_categories = @categories[0].sub_categories
        @product_categories = @sub_categories[0].product_categories
        @attributes = Item.column_names - ['id', 'brand_detail_id', 'category_id', 'sub_category_id', 'product_category_id', 'created_at', 'updated_at']
      else
        flash[:error] = "Invalid File Format"
        redirect_to brand_home_path
      end
    end
  end

  def change_catg
    @sub_categories = Category.where("parent_id = ?", params[:category_id][0])
    @product_categories = @sub_categories[0].product_categories
  end

  def change_sub_catg
    @product_categories = ProductCategory.where("sub_category_id = ?", params[:sub_category_id][0])
  end

  def save
    get_file_content(params[:path])
    save_items_from_file
    File.delete(params[:path])
    flash[:notice] = "Items saved successfully"
    redirect_to brand_items_path
  end

  def details
    @catg = Category.find(params[:catg]).name unless params[:catg].blank? or params[:catg] == "null"
    @sub_catg = Category.find(params[:sub_catg]).name unless params[:sub_catg].blank? or params[:sub_catg] == "null"
    @prod_catg = ProductCategory.find(params[:prod_catg]).name unless params[:prod_catg].blank? or params[:prod_catg] == "null"
    @row = eval(params[:row])
    @row.deep_transform_keys!{|r| r.downcase.gsub(' ', '_').gsub('-', '_')}
    @attributes = Item.column_names - ['id', 'brand_detail_id', 'category_id', 'sub_category_id', 'product_category_id', 'created_at', 'updated_at']
    get_row
  end

  def index
    params[:page] ||=1
    search = Item.solr_search do
      with(:brand_detail_id, current_user.brand_detail.id)
      paginate :page => params[:page], :per_page => 10
      # paginate page: params[:page], per_page: 10
    end
    @items = search.results
    # @items = search.result.page(params[:page]).per(10)
    #@items = current_user.brand_detail.items.paginate(page: params[:page], per_page: 10)
  end

  def show
    @item = current_user.brand_detail.items.find(params[:id])
    if @item.blank?
      flash[:error] = "Invalid Item ID"
      redirect_to brand_items_path
    else
      @attributes = Item.column_names - ['id', 'brand_detail_id', 'category_id', 'sub_category_id', 'product_category_id', 'created_at', 'updated_at']
    end
  end

  def upload_item_images
    unless params[:image_file].blank?
      path = params[:image_file].path
      if params[:image_file].original_filename.end_with? ".zip"
        items = current_user.brand_detail.items
        import_path = Rails.public_path.join(current_user.id.to_s)
        directory = FileUtils.mkdir_p(import_path)
        Zip::ZipFile.open(path) { |zip_file|
      		unless zip_file.blank?
      			zip_file.each do |entry|
              name = entry.name
              next if entry.name =~ /__MACOSX/ or name =~ /\.DS_Store/ or !entry.file?
              dir_name = File.dirname(name)
              if dir_name.length > 3
                item = items.find_by_item_number(dir_name.split('/').last)
                item = items.find_by_sku(dir_name.split('/').last) if item.blank?
                unless item.blank?
                  dir_path = import_path.join(dir_name)
                  FileUtils.mkdir_p(dir_path)
                  f_path = import_path.join(name)
                  entry.extract(f_path)
                  image = item.images.create(title: name.split('/').last, size: entry.size, image_type: MIME::Types.type_for(name)[0].to_s, format: name.split('.').last)
                  image.file = File.open(f_path)
                  image.save
                end
      	      end
      	    end
      		end
        }
        flash[:notice] = "Item images uploaded successfully!!"
        FileUtils.rm_rf(import_path)
      else
        flash[:error] = "Invalid File Format"
      end
    end
    redirect_to brand_items_path
  end

  def destroy
    item = current_user.brand_detail.items.find(params[:id])
    if item.blank?
      flash[:error] = "Invalid Item ID"
    else
      item.destroy
      flash[:success] = "Item deleted successfully!"
    end
    redirect_to brand_items_path
  end

  def download_zip
    items = current_user.brand_detail.items
    export_path = "#{Rails.public_path}/#{current_user.brand_detail.company_name}_items/"
    directory = FileUtils.mkdir_p(export_path)
    items.each do |item|
      item_path = export_path + item.item_number.to_s
      FileUtils.mkdir_p(item_path)
    end

    filename = "#{current_user.brand_detail.company_name}_items.zip"
    temp_file = Tempfile.new(filename)
    Zip::OutputStream.open(temp_file){ |zos| }
    Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
      Dir.foreach(export_path) do |item|
        item_path = "#{export_path}#{item}"
        zip.add( item, item_path )
      end
    end
    zip_data = File.read(temp_file.path)
    send_data(zip_data, :type => 'application/zip', :filename => filename)
    FileUtils.rm_rf(export_path)
  end

  def add_item_images
    @item = current_user.brand_detail.items.find(params[:id])
  end

  def save_item_images
    item = current_user.brand_detail.items.find(params[:id])
    unless params[:item_images].blank?
      params[:item_images].each do |image_obj|
        image = item.images.create(title: image_obj.original_filename, size: image_obj.size, image_type: image_obj.content_type, format: image_obj.original_filename.split('.').last)
        image.file = image_obj
        image.save
      end
    end
    redirect_to brand_items_path
  end

  def download_example
    filename = 'Item_Import_Template.csv'
    send_file "#{Rails.public_path}/templates/#{filename}", :type => 'text/csv', :disposition => 'attachment'
  end

  def selling
    params[:page] ||= 1
    search = Item.solr_search do
      with(:brand_detail_id, current_user.brand_detail.id)
      with(:enabled_for_sale, true)
      paginate page: params[:page], per_page: 10
    end
    params[:enabled_for_sale] = "true"
    # @items = search.result.page(params[:page]).per(10)
    @items = search.results
  end

  def update_list
    params[:page] ||= 1
    search = Item.solr_search do
      with(:brand_detail_id, current_user.brand_detail.id)
      with(:enabled_for_sale, eval(params[:enabled_for_sale]))
      paginate page: params[:page], per_page: 10
    end
    @items = search.results
    # @items = search.result.page(params[:page]).per(10)
  end

  def edit
    @item = current_user.brand_detail.items.find(params[:id])
  end

  def update
    @item = current_user.brand_detail.items.find(params[:id])
    respond_to do |format|
      unless params[:item].blank?
        val = @item.update_attributes(item_params)
      else
        val = @item.update_attributes(item_update_params)
      end
      if val
        format.json { respond_with_bip(@item) }
        format.html { redirect_to brand_selling_items_path }
      else
        format.json { respond_with_bip(@item) }
        format.html { render :action => "edit" }
      end
    end
  end

  def edit_multiple
    @categories = Category.where("parent_id is null")
    @sub_categories = @categories[0].sub_categories
    @product_categories = @sub_categories[0].product_categories
  end

  def update_multiple
    params[:page]||=1
    ids = params[:items].split(',')
    items = Item.where("id in (?)", ids)
    items_params = item_update_params.to_hash
    items_params[:category_id] = params[:category_id][0] unless params[:category_id].blank?
    items_params[:sub_category_id] = params[:sub_category_id][0] unless params[:sub_category_id].blank?
    items_params[:product_category_id] = params[:product_category_id][0] unless params[:product_category_id].blank?
    style_params = params[:style]
    items.each do |item|
      style = (item.style.blank? ? {} : eval(item.style))
      style_params.each do |key, value|
        unless value.blank?
          if style[key].blank?
            style[key] = value
          else
            if style[key].class == String
              style[key] = [style[key]] + value
            else
              style[key]+=value
            end
          end
        end
      end
      items_params["style"] = style
      item.update(items_params)
    end
    # items.update_all(items_params)
    Sunspot.index! items
    search = Item.solr_search do
      with(:brand_detail_id, current_user.brand_detail.id)
      with(:enabled_for_sale, eval(params[:old_enabled_for_sale]))
      paginate page: params[:page], per_page: 10
    end
    params[:enabled_for_sale] = params[:old_enabled_for_sale]
    # @items = search.result.page(params[:page]).per(10)
    @items = search.results
  end

  private
  def item_update_params
    ip = params.permit(:name, :title, :enabled_for_sale, :price, :commission_in_currency, :commission_in_percent)
    ip[:enabled_for_sale] = false if ip[:enabled_for_sale].blank?
    ip
  end

  def item_params
    params.require(:item).permit(:name, :title, :description, :enabled_for_sale, :price, :commission_in_currency, :commission_in_percent)
  end

end
