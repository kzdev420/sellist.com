class ItemMailer < ApplicationMailer

  def send_item_discontinued_notification_to_brand(id)
    @seller_item = SellerItem.find(id)
    @item = @seller_item.item
    @brand = @item.brand_detail.user
  	mail to: @brand.email, subject: "#{@item.name} Discontinued Notification"
  end
end
