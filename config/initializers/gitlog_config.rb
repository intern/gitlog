# Add the default language op
# I18n.backend.class.send(:include, I18n::Backend::Fallbacks)

ActionMailer::Base.default_url_options[:host] = 'iforeach.com'

module GitlogConfig
  RESERVED_KEYWORDS = %w(administrator admin master super account login logout password_reset welcome home online api)
end