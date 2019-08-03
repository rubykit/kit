class ApiController < ActionController::API # :nodoc:
  include Kit::Auth::Controllers::Api::Concerns::CurrentUser

end
