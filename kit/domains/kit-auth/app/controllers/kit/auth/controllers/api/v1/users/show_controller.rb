module Kit::Auth::Controllers::Api::V1::Users
  class ShowController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_UID = 'api_v1|users|show'

    Kit::Router.register(uid: ROUTE_UID, controller: self, action: :endpoint)

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