# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= KIT_APP_PATHS['GEMFILE']

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])

if KIT_APP_PATHS['GEM_LIB']
  $LOAD_PATH.unshift KIT_APP_PATHS['GEM_LIB']
end
