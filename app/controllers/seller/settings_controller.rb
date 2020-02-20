class Seller::SettingsController < Seller::MainController

  def index
    @country = current_user.country
  end

  def update
    current_user.update(user_params)
    seller = current_user.seller_detail
    seller.update(seller_params)
    flash[:success] = "Profile updated successfully!"
    redirect_to seller_settings_path
  end

  private
  def user_params
    params.permit(:first_name, :last_name, :email, :phone, :address, :suit, :city, :state, :postal_code, :country, :profile_pic)
  end

  def seller_params
    sp = params.permit(:ssn_no, :store_name)
    unless params[:date].blank? or params[:month].blank? or params[:year].blank?
      sp[:birth_date] = "#{params[:date]}/#{params[:month]}/#{params[:year]}"
    end
    sp
  end
end
