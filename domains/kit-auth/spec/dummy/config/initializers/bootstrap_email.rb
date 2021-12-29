BootstrapEmail.configure do |config|
  # Defaults to ./bootstrap-email.scss or ./app/assets/stylesheets/bootstrap-email.scss in rails
  config.sass_email_location = File.expand_path('../../app/assets/stylesheets/kit_auth_dummy_emails.scss', __dir__)

  # Defaults to ./bootstrap-head.scss or ./app/assets/stylesheets/bootstrap-head.scss in rails
  #config.sass_head_location = File.expand_path('path/to/bootstrap-head.scss', __dir__)

  # Array of folders to add to the SASS load path to support imports in the custom SASS files
  current_path   = Pathname.new __dir__
  gem_theme_path = Pathname.new Gem.loaded_specs['kit_theme_bootstrap'].full_gem_path
  adjusted_path  = gem_theme_path.relative_path_from(current_path).to_s
  relative_path  = File.expand_path("#{ adjusted_path }/app/assets/stylesheets", current_path.to_s)

  config.sass_load_paths = [relative_path]

  # Defaults to ./.sass-cache or ./tmp/cache/bootstrap-email/.sass-cache in rails
  #config.sass_cache_location = [File.expand_path('some/folder', __dir__)]

  # Defaults to true, is disabled during CLI commands that output to standard out
  #config.sass_log_enabled = true
end
