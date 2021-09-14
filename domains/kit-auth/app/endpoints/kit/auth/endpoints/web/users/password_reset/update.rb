module Kit::Auth::Endpoints::Web::Users::PasswordReset::Update

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_require_current_user!],
        [:alias, :web_redirect_if_missing_scope!],
        [:if, self.method(:update_password), {
          ok:    [self.method(:handle_success)],
          error: [self.method(:handle_error)],
        },],
      ],
      ctx:  {
        router_request: router_request,
        scope:          :user_update_password,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|password_reset|update',
    aliases: ['web|users|password_reset|update'],
    target:  self.method(:endpoint),
  )

  def self.update_password(router_request:)
    model = router_request.params.slice(:password, :password_confirmation)

    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::UpdatePassword,
        Kit::Auth::Actions::Users::SignInWeb,
      ],
      ctx:  {
        router_request: router_request,
        user:           router_request.metadata[:current_user],
      }.merge(model),
    )
  end

  def self.handle_success(router_request:, oauth_access_token_plaintext_secret:)
    # Revoke the password reset access_token
    current_user_oauth_access_token = router_request.metadata[:current_user_oauth_access_token]
    Kit::Auth::Services::OauthAccessToken.revoke(oauth_access_token: current_user_oauth_access_token)

    binding.pry

    # Add the new one to the cookies
    router_request.adapters[:http_rails][:cookies][:access_token] = {
      value:     oauth_access_token_plaintext_secret,
      encrypted: true,
    }

    Kit::Router::Controllers::Http.redirect_to(
      location: Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|password_reset|after'),
      notice:   I18n.t('kit.auth.notifications.password_reset.success'),
    )
  end

  def self.handle_error(router_request:, errors:)
    model = router_request.params.slice(:password, :password_confirmation)

    Kit::Router::Controllers::Http.render(
      router_request: router_request,
      component:      Kit::Auth::Components::Pages::Users::PasswordReset::EditComponent,
      params:         {
        model:       model,
        csrf_token:  router_request.adapters[:http_rails][:csrf_token],
        errors_list: errors,
      },
    )
  end

end
