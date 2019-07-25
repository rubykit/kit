require 'dry-struct'

module Types
  include Dry::Types.module
end

module Kit::Auth::Controllers::Web
  class AuthenticationController < Kit::Auth::Controllers::WebController

    # https://cucumbersome.net/2016/09/06/rails-form-objects-with-dry-rb/

    class FormData < ::Dry::Struct
      attribute :email,    Types::Strict::String
      attribute :password, Types::Strict::String

      # ActiveModel
      def persisted?
        false
      end

      # ActiveModel
      def model_name
        Struct.new(:param_key, :name).new('form', 'form')
      end

      # ActiveModel
      def to_key
        nil
      end
    end

    def new
      if current_user
        redirect_to :web_test
        return
      end

      @model = FormData.new(email: '', password: '')
    end

    def create
      if current_user
        redirect_to :web_test
        return
      end

      @model = FormData.new(params.permit(form: [:email, :password])[:form].to_unsafe_h.symbolize_keys)

      res, ctx = Organizer.call({
        ctx: @model.to_h,
        list: [
          Kit::Auth::Actions::Users::VerifyUserWithPassword,
          Kit::Auth::Actions::Users::GetAccessTokenForUser,
        ],
      })

      if res == :ok
        cookies.encrypted[:access_token] = ctx[:oauth_access_token].token

        # TODO: to fix this we probably need to add config from the top level app that knows the routes
        redirect_to '/'
      else
        render :new
      end
    end

    def delete
      cookies.encrypted[:access_token] = nil

      # TODO: to fix this we probably need to add config from the top level app that knows the routes
      redirect_to '/'
    end

  end
end