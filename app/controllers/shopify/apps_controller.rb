class Shopify::AppsController < Shopify::MainController
  autocomplete :app, :name, :extra_data => [:logo]#, :display_value => :funky_method

  def show
    @apps = App.where(id: params[:id])
  end

  def search
    @apps = App.where(name: params[:app_name])
  end

  def save_recommended_app
    app = current_user.recommended_apps.create(recommended_app_params)
    AppMailer.recommended_app_notification(app.id).deliver
    flash[:notice] = "Details have been sent to Sellist Team. Thanks for your response!"
  end

  private
  def recommended_app_params
    params.permit(:name, :url)
  end
end
