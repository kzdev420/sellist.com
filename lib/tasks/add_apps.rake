desc "Add apps to DataBase"

task :add_apps => :environment do

  save_app("shopify")
  save_app("quickbooks")
  save_app("Volusion")
  save_app("Wix")
  save_app("BigCommerce")
  save_app("Magento")
  save_app("prestashop")
  save_app("squarespace")
  save_app("woocommerce")
  save_app("NetSuite")
  save_app("xero")
  save_app("stitch")
  save_app("sellbrite")
  save_app("bigcartel")
  save_app("3dcart")
end

def save_app(name)
  app = App.create(name: name.downcase, url: "#{name.downcase}.com")
  if name == "quickbooks"
    image_path = "#{Rails.root.to_s}/app/assets/images/QB.png"
  else
    image_path = "#{Rails.root.to_s}/app/assets/images/#{name}.png"
  end
  app.logo = File.open(image_path)
  app.save
end
