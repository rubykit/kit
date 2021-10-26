module Kit # rubocop:disable Style/Documentation
end

module Kit::Api # rubocop:disable Style/Documentation
end

if Rails.env.in?(%w[development test])
  require_relative 'api/engine'
else
  require_relative 'api/railtie'
end
