module Kit::Auth::Controllers::Api::V1::Users
  class CreateController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    ROUTE_UID = 'api_v1|users|create'

    Kit::Router.register(uid: ROUTE_UID, controller: self, action: :endpoint)

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