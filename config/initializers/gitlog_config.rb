# Add the default language op
I18n.backend.class.send(:include, I18n::Backend::Fallbacks)
ActionMailer::Base.default_url_options[:host] = 'iforeach.com'
