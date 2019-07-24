# frozen_string_literal: true

module Kit::Auth::Controllers::Api::V1
  class UsersController < ApiV1Controller # :nodoc:

    def show
      params.permit(:id)

      resource = Kit::Auth::Models::Read::User.find_by(id: params[:id])

      if resource
        status = :ok
        body   = Kit::Auth::Serializers::User.new(resource).serialized_json
      else
        status = :not_found
        body   = nil
      end


      render status: status, json: body
    end

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

  end
end