require 'rails_admin/support/i18n'

module RailsAdmin
  module CustomHelper
    include RailsAdmin::Support::I18n

    def static_navigation
      li_stack = RailsAdmin::Config.navigation_static_links.collect do |title, url|
        content_tag(:li, link_to(title.to_s, url))
      end.join

      label = RailsAdmin::Config.navigation_static_label || t('admin.misc.navigation_static_label')
      li_stack = %(<li class='dropdown-header'>#{label}</li>#{li_stack}).html_safe if li_stack.present?
      li_stack
    end
  end
end
