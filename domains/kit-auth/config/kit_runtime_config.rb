KIT_APP_PATHS ||= {}

KIT_APP_PATHS['GEM_RAILTIE']     = 'kit/auth'

KIT_APP_PATHS['GEM_ROOT']        = File.expand_path('..', __dir__)
KIT_APP_PATHS['GEM_APP']         = File.expand_path('../app', __dir__)
KIT_APP_PATHS['GEM_LIB']         = File.expand_path('../lib', __dir__)
KIT_APP_PATHS['GEMFILE']         = File.expand_path('../Gemfile', __dir__)
KIT_APP_PATHS['GEM_ASSETS']      = [
  #File.expand_path('../app/assets', __dir__),
  File.expand_path('../spec/dummy/app/assets/stylesheets', __dir__),
  File.expand_path('../spec/dummy/app/assets/javascripts', __dir__),
  File.expand_path('../spec/dummy/app/assets/images', __dir__),
]

KIT_APP_PATHS['GEM_SPEC_ROOT']   = File.expand_path('../spec/dummy', __dir__)
KIT_APP_PATHS['GEM_SPEC_APP']    = File.expand_path('../spec/dummy/app', __dir__)
KIT_APP_PATHS['GEM_SPEC_LIB']    = File.expand_path('../spec/dummy/lib', __dir__)
KIT_APP_PATHS['GEM_SPEC_ROUTES'] = File.expand_path('../spec/dummy/config/routes.rb', __dir__)
KIT_APP_PATHS['GEM_SPEC_VIEWS']  = File.expand_path('../spec/dummy/app/views', __dir__)
KIT_APP_PATHS['GEM_SPEC_DB']     = File.expand_path('../spec/dummy/db', __dir__)

KIT_APP_PATHS['GEM_SPEC_VIEW_LAYOUT'] = 'kit_auth_dummy_application'

KIT_APP_PATHS['EXECUTE'] ||= []
KIT_APP_PATHS['EXECUTE'] << ->(config:) do
  if Rails.env.development? || Rails.env.test?
    config.factory_bot.definition_file_paths = [
      File.expand_path('../spec/factories', __dir__),
    ]
  end
end

KIT_APP_PATHS['RAILS_DEPENDENCIES'] = %w[
  active_record/railtie
  action_controller/railtie
  action_view/railtie
  action_mailer/railtie
  active_job/railtie
  sprockets/railtie
]
