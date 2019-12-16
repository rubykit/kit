module Kit
  module JsonApi
  end
end

if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
  require "kit/json_api/engine"
else
  require "kit/json_api/railtie"
end
