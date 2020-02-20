class App < ApplicationRecord
  mount_uploader :logo, ImageUploader

  def funky_method
    val = "<img src='#{self.logo.url}'> #{self.name.camelize}"
    content_tag('b', val).html_safe
    #"#{self.name.camelize}"
  end
end
