module Kit::Auth::Helpers
  module CurrentUserHelper
    def current_user
      request[:current_user]
    end
  end
end