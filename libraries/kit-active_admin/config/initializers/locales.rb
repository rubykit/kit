path = File.expand_path('../locales', __dir__)

Rails.application.config.i18n.load_path += Dir["#{ path }/**/*.{rb,yml}"]
