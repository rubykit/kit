module Kit::Auth::Controllers
  class WebController < ActionController::Base

    include Kit::Auth::Controllers::Concerns::CurrentUser

    protect_from_forgery with: :exception

  end
end
