module Kit::Api # rubocop:disable Style/Documentation
end

module Kit::Api::JsonApi # rubocop:disable Style/Documentation
end

if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
  require 'kit/api/json_api/engine'
else
  require 'kit/api/json_api/railtie'
end
