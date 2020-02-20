class Users::RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def check_email
    user = User.find_by_email(params[:user][:email])
    respond_to do |format|
      format.json { render :json => !user }
    end
  end

  def initialize_user
    @user = User.new(registration_params)
    @country = "US"
  end

  def change_states
    @country = params[:country]
  end

  def create
    @user = User.new(registration_params)
    if @user.save
      if @user.account_type == "seller"
        @user.create_seller_detail(seller_params)
      else
        @user.create_brand_detail(brand_params)
      end
      session[:user_id] = @user.id
      redirect_to user_activation_path
    else
      #render action: 'initialize_user'
    end
  end

  def activation
    @user = User.find(session[:user_id]) unless session[:user_id].blank?
    params[:type] = @user.account_type unless @user.blank?
  end

  def activate_user
    unless params[:activation_key].blank?
      user = User.find_by_confirmation_token(params[:activation_key])
      unless user.blank?
        user.confirm
        user.update(active: true, confirmed_at: Time.now)
        flash[:notice] = "Your account is activated. Please login!"
        redirect_to root_path
      else
        render action: 'activation'
      end
    end
  end

  private
  def registration_params
    up = params.require(:user).permit(:account_type, :email, :password, :password_confirmation, :first_name, :last_name, :address, :suit, :city, :state, :country, :postal_code)
    up[:is_admin] = true
    up
  end

  def seller_params
    sp = params.permit(:ssn_no, :store_name)
    unless params[:date].blank? or params[:month].blank? or params[:year].blank?
      sp[:birth_date] = "#{params[:date]}/#{params[:month]}/#{params[:year]}"
    end
    sp
  end

  def brand_params
    params.permit(:company_name, :ein, :web_address, :annual_revenue)
  end
end
