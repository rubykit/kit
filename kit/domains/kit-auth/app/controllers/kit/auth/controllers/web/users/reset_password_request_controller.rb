module Kit::Auth::Controllers::Web::Users
  class ResetPasswordRequestController < Kit::Auth::Controllers::WebController

    before_action *[
      :redirect_if_current_user!,
    ]

    Kit::Router.register(uid: 'kit_auth|web|users|reset_password_request|new', aliases: ['web|users|reset_password_request|new'], controller: self, action: :new)

    def new
      @model = { email: nil }
    end


    Kit::Router.register(uid: 'kit_auth|web|users|reset_password_request|create', aliases: ['web|users|reset_password_request|create'], controller: self, action: :create)

    def create
      @model = params.to_h.slice(:email).symbolize_keys

      context = @model.merge(
        request:           request,
        oauth_application: ::Doorkeeper::Application.find_by!(uid: 'webapp'),
      )

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          Kit::Auth::Actions::Users::FindUserByEmail,
          Kit::Auth::Actions::Users::CreateResetPasswordAuthorizationToken,
          Kit::Auth::Actions::UserRequestMetadata::CreateUserRequestMetadata,
          Kit::Auth::Actions::OauthAccessTokens::UpdateUserRequestMetadata,
        ],
      })

      # Redirect regardless
      redirect_to Kit::Router.path(id: 'web|users|after_reset_password_request'), notice: I18n.t('kit.auth.passwords.send_paranoid_instructions')
    end

  end
end