module Kit
  module JsonApi
  end
end

if ENV['ENV'] == 'development' || ENV['ENV'] == 'test'
  require "kit/json_api/engine"
else
  require "kit/json_api/railtie"
end
