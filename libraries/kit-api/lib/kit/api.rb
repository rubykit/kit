module Kit # rubocop:disable Style/Documentation
end

module Kit::Api # rubocop:disable Style/Documentation
end

if ENV['RAILS_ENV'] == 'development' || ENV['RAILS_ENV'] == 'test'
  require 'kit/api/engine'
else
  require 'kit/api/railtie'
end
