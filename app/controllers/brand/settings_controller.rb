class Brand::SettingsController < Brand::MainController

  def index
    @country = current_user.country
  end

  def update
    current_user.update(user_params)
    brand = current_user.brand_detail
    brand.update(brand_params)
    flash[:success] = "Profile updated successfully!"
    redirect_to brand_settings_path
  end

  private
  def user_params
    params.permit(:first_name, :last_name, :email, :phone, :address, :suit, :city, :state, :postal_code, :country, :profile_pic)
  end

  def brand_params
    params.permit(:company_name, :ein, :web_address, :annual_revenue)
  end
end
