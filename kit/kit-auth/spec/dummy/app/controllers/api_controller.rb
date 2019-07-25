class ApiController < ActionController::API # :nodoc:
  include Kit::Auth::Controllers::Concerns::CurrentUser

end
