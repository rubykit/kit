module Kit::Auth::Controllers::Web::Users::ResetPassword
  module Update

    def self.endpoint(request:)
      Kit::Organizer.call({
        ctx:  { request: request, },
        list: [
          :require_current_user!,
          # TODO: fix this explicit dependency, not sure how?
          ->(ctx) { Kit::Auth::Controllers::WebController.redirect_if_missing_scope!(request: ctx[:request], scope: 'update_user_secret') },
          self.method(:render_view),
        ],
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|users|reset_password|update',
      aliases: ['web|users|reset_password|update'],
      target:  self.method(:endpoint),
    })

    def self.update_password(request:)
      model   = request.params.slice(:password, :password_confirmation)
      context = model.merge(
        user:    request.metadata[:current_user],
        request: request,
      )

      status, ctx = Kit::Organizer.call({
        ctx: context,
        list: [
          Kit::Auth::Actions::Users::UpdatePassword,
          Kit::Auth::Actions::Users::SignInWeb,
        ],
      })

      if status == :ok
        Kit::Auth::Services::OauthAccessToken.revoke(oauth_access_token: current_user_oauth_access_token)

        request.http.cookies[:access_token] = { value: ctx[:oauth_access_token_plaintext_secret], encrypted: true }

        Kit::Router::Controllers::Http.redirect_to(
          location: Kit::Router::Services::Router.path(id: 'web|users|after_reset_password'),
          notice:   I18n.t('kit.auth.passwords.updated'),
        )
      else
        Kit::Router::Controllers::Http.render(
          component: Kit::Auth::Components::Pages::Users::ResetPassword::Edit,
          params: {
            model:       model,
            csrf_token:  request.http[:csrf_token],
            errors_list: ctx[:errors],
          },
        )
      end
    end

  end
end