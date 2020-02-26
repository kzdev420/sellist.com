class CustomSpree::Users::RegistrationsController < ApplicationController
  layout "application"

  def new
    @user = User.new
  end

  def check_email
    user = User.find_by_email(params[:user][:email])
    respond_to do |format|
      format.json { render :json => !user }
    end
  end

  def change_states
    @country = params[:country]
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      redirect_to root_path
    else
      render action: 'new'
    end
  end

  private
  def registration_params
    up = params.require(:user).permit(:account_type, :email, :password, :password_confirmation, :first_name, :last_name, :address, :suit, :city, :state, :country, :postal_code)
    up[:is_admin] = true
    up
  end
end
