module Kit::Auth::Controllers::Web::Users
  class ResetPasswordRequestController < Kit::Auth::Controllers::WebController

=begin
    before_action *[
      :redirect_if_current_user!,
    ]

    Kit::Router.register({
      uid:         'kit_auth|web|users|reset_password_request|new',
      aliases:     ['web|users|reset_password_request|new'],
      object:      self,
      method_name: :new_reset_password_request,
    })

    def self.new_reset_password_request(request:)
      model = { email: nil }

      page = Kit::Auth::Components::Pages::Users::ResetPasswordRequest.new(
        model:      model,
        csrf_token: request.http[:csrf_token],
      )
      content = page.local_render

      [:ok, {
        mime:    :html,
        content: content,
      }]
    end


    Kit::Router.register({
      uid:         'kit_auth|web|users|reset_password_request|create',
      aliases:     ['web|users|reset_password_request|create'],
      object:      self,
      method_name: :create_reset_password_request,
    })

    def self.create_reset_password_request(request:)
      model = request.params.slice(:email)

      context = {
        user:    User.find_by(email: @model[:email]),
        request: request,
      }

      res, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          Kit::Auth::Actions::OauthApplications::LoadWeb,
          Kit::Auth::Actions::RequestMetadata::Create,
          Kit::Auth::Actions::Users::CreateResetPasswordAuthorizationToken,
          Kit::Auth::Actions::OauthAccessTokens::UpdateRequestMetadata,

          Kit::Auth::Actions::Users::FindUserByEmail,
          Kit::Auth::Actions::RequestMetadata::Create,
          Kit::Auth::Actions::OauthAccessTokens::UpdateRequestMetadata,
        ],
      })

      # Redirect regardless
      redirect_to Kit::Router.path(id: 'web|users|after_reset_password_request'), notice: I18n.t('kit.auth.passwords.send_paranoid_instructions')
    end


    #def process
    #end
=end

  end
end