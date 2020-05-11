module Kit::Api
  module JsonApi
  end
end

if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
  require "kit/api/json_api/engine"
else
  require "kit/api/json_api/railtie"
end
