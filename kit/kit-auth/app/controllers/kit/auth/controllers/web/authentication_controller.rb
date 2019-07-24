require 'dry-struct'

module Types
  include Dry::Types.module
end


module Kit::Auth::Controllers::Web
  class AuthenticationController < WebController

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
        redirect_to 'home'
      else
        render :new
      end
    end

    def test
      render json: { user_id: current_user.id }
    end

    def delete
      cookies.encrypted[:access_token] = nil

      redirect_to 'home'
    end

  end
end