require 'doorkeeper'

module Kit # rubocop:disable Style/Documentation
end

module Kit::Auth # rubocop:disable Style/Documentation
  Doorkeeper = ::Doorkeeper
end

require 'kit/auth/engine'
require 'kit/auth/routes'
