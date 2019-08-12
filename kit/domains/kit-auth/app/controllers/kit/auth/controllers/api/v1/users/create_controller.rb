module Kit::Auth::Controllers::Api::V1::Users
  class CreateController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_ID  = 'api_v1|users|create'
    ROUTE_UID = "kit_auth|#{ROUTE_ID}"

    Kit::Router.register(uid: ROUTE_UID, aliases: [ROUTE_ID], controller: self, action: :endpoint)

    def endpoint
      safe_params = params.permit(:email, :password, :password_confirmation).to_h

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