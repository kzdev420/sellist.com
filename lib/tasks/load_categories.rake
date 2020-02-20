desc "Fetching Public Sensors Data"

namespace :load_categories do
  task :from_csv => :environment do
    require 'csv'

    file_path = "#{Rails.public_path}/Category_List_Sheet.csv"

    #file = File.open(file_path, "r:ISO-8859-1")
  	#CSV.parse(file, headers: true) do |row|
    #end

    csv = CSV.read(file_path, headers: true)
    headers = csv.headers
    headers.each do |header|
      puts csv[header]
    end
  end

  task :from_excel => :environment do
    require 'spreadsheet'

    Spreadsheet.client_encoding = 'UTF-8'
    file_path = "#{Rails.public_path}/Category_List.xls"
    book = Spreadsheet.open(file_path)
    sheet = book.worksheet(0)
    rows = sheet.rows

    sheet.columns.each do |column|
      col_index = column.idx
      @catg = ''
      @sub_catg = ''
      column.each_with_index do |cell, index|
        unless cell.blank?
          row = sheet.row(index)
          format = row.format col_index
          color = format.font.color.to_s.downcase
          if color == "xls_color_22"
            @catg = Category.find_or_create_by(name: cell)
          elsif color == "xls_color_45" or color == "red"
            @sub_catg = Category.find_or_create_by(name: cell, parent_id: @catg.id)
          elsif color == "black" or color == "text"
            item_catg = ProductCategory.find_or_create_by(name: cell, category_id: @catg.id, sub_category_id: @sub_catg.id)
          else
            puts cell
          end
        end
      end
    end
  end

end
