class Seller::MainController < ApplicationController
  before_action :authenticate_user!, :check_user_type

  private
  def check_user_type
    redirect_to user_home_path unless current_user.seller
  end
end
