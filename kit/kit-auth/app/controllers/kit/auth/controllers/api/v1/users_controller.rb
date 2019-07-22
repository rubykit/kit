# frozen_string_literal: true

module Kit::Auth::Controllers::Api::V1
  class UsersController < ApiV1Controller # :nodoc:

    def show
      params.permit(:id)

      resource = Models::Read::User.find_by!(id: params[:id])

      render json: Serializers::User.new(resource).serialized_json
    end

    def create
      params.permit(:email)

      resource = Models::Write::User.create_by!(email: params[:email])

      render json: Serializers::User.new(resource).serialized_json
    end

    end
  end
end