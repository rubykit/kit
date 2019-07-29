module Kit::Auth::Helpers
  module CurrentUserHelper
    def current_user
      request.instance_variable_get(:@current_user)
    end
  end
end