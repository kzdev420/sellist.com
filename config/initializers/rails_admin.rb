RailsAdmin.config do |config|
  include RailsAdmin::CustomHelper
  ### Popular gems integration

  ## == Devise ==
  config.authorize_with do
    if current_user
      unless current_user and current_user.is_super_admin
        flash[:error] = "You are not an admin"
        redirect_to '/'
      end
    else
      flash[:error] = "You need to sign in or sign up before continuing."
      redirect_to '/'
    end
    config.current_user_method(&:current_user)
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model Item do
    include_all_fields
    field :price do
      def value
        '%.2f' % bindings[:object].price
      end
    end
  end

  config.model 'ProductCategory' do
    visible false
  end

  config.model 'Category' do
    visible false
  end

  # config.navigation_static_links = {
  #   'Google' => 'http://www.google.com'
  # }
end
