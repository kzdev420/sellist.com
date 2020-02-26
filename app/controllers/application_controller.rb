class ApplicationController < ActionController::Base
  # skip_before_action :verify_authenticity_token
  protect_from_forgery with: :exception

  layout :custom_layout

  include Spree::AuthenticationHelpers
  include Spree::CurrentUserHelpers
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Store
  helper 'spree/base'

  def current_store
    Spree::Store.find_by_url(request.base_url.split("/").last)
  end

  def custom_layout
    if (devise_controller? and controller_name == "sessions") or controller_name == "sessions"
      "login_layout"
    elsif current_user
      "user_home"
    else
      "application"
    end
  end

  def after_sign_up_path_for(resource_or_scope)
    session[:spree_user_signup] = true
    stored_location_for(resource_or_scope) || super
  end

  def after_sign_in_path_for(resource)
    if resource.active
      session[:spree_user_signin] = true
      if resource.is_super_admin
        '/rails-admin'
      # elsif try_spree_current_user.try(:has_spree_role?, "admin")
      #   '/admin', subdomain: "admin"
      else
        user_home_path
      end
    else
      sign_out resource
      root_path
    end
  end
end
