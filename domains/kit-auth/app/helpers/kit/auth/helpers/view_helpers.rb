module Kit::Auth::Helpers
  module ViewHelpers

    def current_user
      kit_router_request = request.instance_variable_get(:@kit_router_request)
      return nil if !kit_router_request

      kit_router_request.metadata[:current_user]
    end

    def current_user_oauth_access_token
      kit_router_request = request.instance_variable_get(:@kit_router_request)
      return nil if !kit_router_request

      kit_router_request.metadata[:current_user_oauth_access_token]
    end

  end
end
