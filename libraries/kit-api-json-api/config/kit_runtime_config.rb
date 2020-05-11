KIT_APP_PATHS ||= {}

KIT_APP_PATHS['GEM_RAILTIE']     = 'kit_api_json_api'

KIT_APP_PATHS['GEM_ROOT']        = File.expand_path('..', __dir__)
KIT_APP_PATHS['GEM_APP']         = File.expand_path('../app', __dir__)
KIT_APP_PATHS['GEM_LIB']         = File.expand_path('../lib', __dir__)
KIT_APP_PATHS['GEMFILE']         = File.expand_path('../Gemfile', __dir__)

KIT_APP_PATHS['GEM_SPEC_ROOT']   = File.expand_path('../spec/dummy', __dir__)
KIT_APP_PATHS['GEM_SPEC_APP']    = File.expand_path('../spec/dummy/app', __dir__)
KIT_APP_PATHS['GEM_SPEC_LIB']    = File.expand_path('../spec/dummy/lib', __dir__)
KIT_APP_PATHS['GEM_SPEC_ROUTES'] = File.expand_path('../spec/dummy/config/routes.rb', __dir__)
KIT_APP_PATHS['GEM_SPEC_DB']     = File.expand_path('../spec/dummy/db', __dir__)
KIT_APP_PATHS['GEM_SPEC_INITIALIZERS'] = [
  File.expand_path('../spec/dummy/config/initializers/eager_load_controllers.rb', __dir__),
]
