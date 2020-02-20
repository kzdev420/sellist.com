class HomeController < ApplicationController

  def index
  end

  def user
    if current_user.brand
      redirect_to brand_dashboard_path
    elsif current_user.seller
      redirect_to seller_dashboard_path
    elsif current_user.is_super_admin
      redirect_to '/admin'
    end
  end
end
