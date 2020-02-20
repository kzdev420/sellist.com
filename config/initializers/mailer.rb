ActionMailer::Base.smtp_settings = {
  address:        'mail.smtp2go.com', # default: localhost
  port:           587,                  # default: 25
  #domain: 'mail.google.com',
  user_name:      'omerpucit@technodevs.com',
  password:       'VqsfKEZPHdNB',
  authentication: :plain,                 # :plain, :login or :cram_md5
  enable_starttls_auto: true
}
