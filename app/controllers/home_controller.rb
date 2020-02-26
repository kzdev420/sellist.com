class HomeController < ApplicationController

  def index
  end

  def user
    if current_user.brand
      redirect_to brand_dashboard_path
    elsif current_user.seller
      redirect_to seller_dashboard_path
    elsif current_user.is_super_admin
      redirect_to '/rails-admin', subdomain: ""
    elsif try_spree_current_user.try(:has_spree_role?, "admin")
      sign_out current_user
      redirect_to root_path
      # redirect_to "http://admin.lvh.me:3011/admin"
      # redirect_to '/admin', subdomain: "admin"
    end
  end
end
