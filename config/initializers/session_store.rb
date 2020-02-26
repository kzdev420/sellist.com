# Rails.application.config.session_store :active_record_store#, :domain => :all#, :tld_length => 2

Rails.application.config.session_store :active_record_store, :key => 'sellist_cookies'

# if Rails.env.production?
#   Rails.application.config.session_store :active_record_store, {:key => 'sellist_cookies', :domain => :all}
# else
#   Rails.application.config.session_store :active_record_store, :key => 'sellist_cookies'
# end
