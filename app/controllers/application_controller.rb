class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  layout :custom_layout

  def custom_layout
    if devise_controller? and controller_name == "sessions"
      "login_layout"
    elsif current_user
      "user_home"
    else
      "application"
    end
  end

  def after_sign_in_path_for(resource)
    if resource.active
      if resource.is_super_admin
        '/admin'
      else
        user_home_path
      end
    else
      sign_out resource
      root_path
    end
  end
end
