ActionMailer::Base.smtp_settings = {
  address:        'smtp.gmail.com', # default: localhost
  port:           587,                  # default: 25
  domain: 'mail.google.com',
  user_name:      'sellist.beryl@gmail.com',
  password:       'Berylsystems@123',
  authentication: :plain,                 # :plain, :login or :cram_md5
  enable_starttls_auto: true
}
