class WebController < ActionController::Base
  include Kit::Auth::Controllers::Concerns::CurrentUser

  layout 'application'

end
