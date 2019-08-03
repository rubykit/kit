class WebController < ActionController::Base
  include Kit::Auth::Controllers::Web::Concerns::CurrentUser

  layout 'application'

end
