class CustomSpree::Users::SessionsController < ApplicationController
  layout "login_layout"

  def new
    @user = User.new
  end

  def create
    user = User.find_for_authentication(:email => params[:user][:email])
    unless user.blank?
      if user.valid_password?(params[:user][:password])
        if user.try(:has_spree_role?, "admin")
          sign_in user
          session[:spree_user_signin] = true
          redirect_to '/admin'
        else
          redirect_to root_url(:host => request.domain)
          # redirect_to APP_CONFIG['site_url']
        end
      else
        flash[:error] = "Email/Password doesn't match"
        render action: "new"
      end
    else
      flash[:error] = "Email/Password doesn't match"
      render action: "new"
    end
  end

  def logout
    sign_out current_user
    redirect_to root_path
  end
end
