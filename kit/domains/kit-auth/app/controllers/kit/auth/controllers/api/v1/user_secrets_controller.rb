# frozen_string_literal: true

module Kit::Auth::Controllers::Api::V1
  class UsersSecretsController < ApiV1Controller # :nodoc:
    doorkeeper_for :update, :create, :scopes => [:update_user_secret]

    def create
    end

    def update
    end

  end
end