require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |username, password|
  username == APP_CONFIG['SIDEKIQ_USERNAME'] && password == APP_CONFIG['SIDEKIQ_PASSWORD']
end if Rails.env.production?
