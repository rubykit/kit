module Kit::Auth::Controllers
  # NOTE: This is a little backward: we inherit from the engine container controller in order to display the layout
  class WebController < ::WebController

    #include Kit::Auth::Controllers::Web::Concerns::RailsCurrentUser

    protect_from_forgery with: :exception

  end
end
