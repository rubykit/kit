# frozen_string_literal: true

module Kit::Auth::Controllers::Api::V1
  class UsersController < Kit::Auth::Controllers::Api::ApiV1Controller # :nodoc:

    # Show ---------------------------------------------------------------------

    afore_action :show, list: [
      :require_current_user!,
      -> { load_resource!(model: Kit::Auth::Models::Read::User, param: :id) },
      -> { require_belongs_to!(parent: current_user, child: resource) },
    ]

    def show
      render({
        status: :ok,
        jsonapi: resource,
      })
    end


    # Create -------------------------------------------------------------------

=begin
    def create
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
=end

  end
end