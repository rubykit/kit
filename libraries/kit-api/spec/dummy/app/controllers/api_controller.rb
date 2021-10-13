class ::ApiController < ::ActionController::API # rubocop:disable Style/Documentation

  # Adds default route wrapper.
  include Kit::Api::JsonApi::Controllers::Concerns::DefaultRoute

end
