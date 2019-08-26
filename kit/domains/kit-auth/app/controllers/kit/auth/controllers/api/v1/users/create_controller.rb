module Kit::Auth::Controllers::Api::V1::Users
  class CreateController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_ID  = 'api_v1|users|create'
    ROUTE_UID = "kit_auth|#{ROUTE_ID}"

    Kit::Router::Services::Router.register_rails_action(uid: ROUTE_UID, aliases: [ROUTE_ID, 'api|users|create'], controller: self, action: :endpoint)

    def endpoint
      safe_params = params.slice(:email, :password, :password_confirmation)

      res, ctx = Kit::Auth::Actions::Users::CreateUserWithPassword(safe_params)

      if res == :ok
        status = :created
        body   = Kit::Auth::Serializers::User.new(ctx[:user]).serialized_json
      else
        status = 400
        body   = ctx[:errors]
      end

      render status: status, json: body
    end

  end
end