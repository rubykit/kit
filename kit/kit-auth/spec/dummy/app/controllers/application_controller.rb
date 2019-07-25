class ApplicationController < ActionController::Base
  include Kit::Auth::Controllers::Concerns::CurrentUser

end
