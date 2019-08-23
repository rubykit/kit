class WebController < ActionController::Base
  include Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

  layout 'application'

end
