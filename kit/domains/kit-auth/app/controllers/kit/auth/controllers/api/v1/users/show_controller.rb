module Kit::Auth::Controllers::Api::V1::Users
  class ShowController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_ID  = 'api_v1|users|show'
    ROUTE_UID = "kit_auth|#{ROUTE_ID}"

    Kit::Router::Services::Router.register_rails_action(uid: ROUTE_UID, aliases: [ROUTE_ID, 'api|users|show'], controller: self, action: :endpoint)

    before_action *[
      :require_current_user!,
      -> { load_resource!(model: Kit::Auth::Models::Read::User, param: :id) },
      -> { require_belongs_to!(parent: current_user, child: resource) },
    ]

    def endpoint
      render({
        status: :ok,
        jsonapi: resource,
      })
    end

  end
end