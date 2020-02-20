module Brand::ItemsHelper

  def save_file_temporarily(file)
    # Save File in Temporary Path
    filename = file.original_filename.gsub(' ', '_').split('.')[0] + '.csv'
    @path = Rails.public_path + filename
    #File.open(@path, 'wb') do |f| f.write(File.read(file.path, :encoding => 'ISO-8859-1')) end
    CSV.open(@path, 'wb') do |csv|
      csv << @csv.headers
      @csv.to_a.each_with_index do |row, index|
        unless index == 0
          row.map{|cell| cell.gsub!("\n", '') unless cell.blank?}
          csv << row
        end
      end
    end
  end

  def get_file_content(path)
    if path.end_with? ".xlsx"
      xlsx = Roo::Spreadsheet.open(path)
      sheet = xlsx.sheet(0)
      @csv = CSV.parse(sheet.to_csv, headers: true)
    elsif path.end_with? ".xls"
      xls = Roo::Excel.new(path)
      sheet = xls.sheet(0)
      @csv = CSV.parse(sheet.to_csv, headers: true)
    elsif path.end_with? ".csv"
      @csv = CSV.read(path, headers: true)
    end
  end

  def save_items_from_file
    @csv.each_with_index do |row, index|
      item_attributes = {}
      item_attributes['style'] = {}
      @csv.headers.each do |header|
        unless header.blank?
          new_header = header.downcase.gsub(' ', '_').gsub('-', '_')
          if new_header.include? 'category'
            if new_header.include? "primary" or new_header.include? "main"
              item_attributes['category_id'] = params[:category_id][index]
            elsif new_header.include? "sub"
              item_attributes['sub_category_id'] = params[:sub_category_id][index]
            else
              item_attributes['product_category_id'] = params[:product_category_id][index]
            end
          else
            col = params[:attributes][header]
            unless col.blank?
              if col == "style"
                if new_header.include? "attribute"
                  unless row[header].blank?
                    if new_header.include? "type"
                      item_attributes['style'][row[header]] = '' unless item_attributes['style'].keys.include? row[header]
                    else
                      type_header = header.split('#')[0] + 'Type #' + header.split('#')[1]
                      type_header = header.split('#')[0] + 'type #' + header.split('#')[1] unless item_attributes['style'].keys.include? row[type_header]
                      if item_attributes['style'].keys.include? row[type_header]
                        value = item_attributes['style'][row[type_header]]
                        if value.blank?
                          item_attributes['style'][row[type_header]] = row[header]
                        else
                          if value.class == String
                            item_attributes['style'][row[type_header]] = [value, row[header]]
                          else
                            item_attributes['style'][row[type_header]] << row[header]
                          end
                        end
                      end
                    end
                  end
                else
                  if item_attributes['style'].keys.include? header
                    value = item_attributes['style'][header]
                    if value.blank?
                      item_attributes['style'][header] = row[header]
                    else
                      if value.class == String
                        item_attributes['style'][header] = [value, row[header]]
                      else
                        item_attributes['style'][header] << row[header]
                      end
                    end
                  else
                    item_attributes['style'][header] = row[header]
                  end
                end
              else
                item_attributes[col] = row[header]
              end
            end
          end
        end
      end
      item_attributes['style'] = item_attributes['style'].compact.to_s
      brand = current_user.brand_detail
      brand.items.create(item_attributes)
      Item.index
    end
  end

  def save_items_from_file1
    @csv.each_with_index do |row, index|
      item_attributes = {}
      item_attributes['style'] = {}
      @csv.headers.each do |header|
        unless header.blank?
          new_header = header.downcase.gsub(' ', '_').gsub('-', '_')
          if new_header.include? "attribute"
            unless row[header].blank?
              if new_header.include? "type"
                item_attributes['style'][row[header]] = '' unless item_attributes['style'].keys.include? row[header]
              else
                type_header = header.split('#')[0] + 'Type #' + header.split('#')[1]
                if item_attributes['style'].keys.include? row[type_header]
                  value = item_attributes['style'][row[type_header]]
                  if value.blank?
                    item_attributes['style'][row[type_header]] = row[header]
                  else
                    if value.class == String
                      item_attributes['style'][row[type_header]] = [value, row[header]]
                    else
                      item_attributes['style'][row[type_header]] << row[header]
                    end
                  end
                end
              end
            end
          elsif new_header.include? 'category'
            if new_header.include? "primary" or new_header.include? "main"
              item_attributes['category_id'] = params[:category_id][index]
            elsif new_header.include? "sub"
              item_attributes['sub_category_id'] = params[:sub_category_id][index]
            else
              item_attributes['product_category_id'] = params[:product_category_id][index]
            end
          else
            unless row[header].blank?
              col = params[:attributes][header]
              unless col.blank?
                item_attributes[col] = row[header]
              end
            end
          end
        end
      end
      item_attributes['style'] = item_attributes['style'].to_s
      brand = current_user.brand_detail
      brand.items.create(item_attributes)
      Item.index
    end
  end

  def get_row
    @new_row = {}
    @new_row['style'] = {}
    @row.each do |k,v|
      if k.include? 'category'
        if k.include? "primary" or k.include? "main"
          @new_row['category_id'] = params[:catg]
        elsif k.include? "sub"
          @new_row['sub_category_id'] = params[:sub_catg]
        else
          @new_row['product_category_id'] = params[:prod_catg]
        end
      elsif k.include? "attribute"
        unless v.blank?
          if k.include? "type"
            @new_row['style'][v] = '' unless @new_row['style'].keys.include? v
          else
            type_header = k.split('#')[0] + 'type_#' + k.split('#')[1]
            #type_header = k.split('#')[0] + 'type #' + k.split('#')[1] unless @new_row['style'].keys.include? @row[type_header]
            if @new_row['style'].keys.include? @row[type_header]
              value = @new_row['style'][@row[type_header]]
              if value.blank?
                @new_row['style'][@row[type_header]] = v
              else
                if value.class == String
                  @new_row['style'][@row[type_header]] = [value, v]
                else
                  @new_row['style'][@row[type_header]] << v
                end
              end
            end
          end
        end
      else
        col = @attributes.select{ |attrib| k.include? attrib or attrib.include? k }
        unless col.blank?
          if col.length > 1
            count = 0
            col.each do |c|
              if c == k
                @new_row[c] = v
                count+=1
              end
            end
            if count == 0
              @new_row[col[0]] = v
            end
          else
            @new_row[col[0]] = v
          end
        end
      end
    end
    @new_row['style'] = @new_row['style'].compact.to_s
  end

end
