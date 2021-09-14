module Kit::Auth::Endpoints::Web::Users::PasswordResetRequest::Create

  def self.endpoint(router_request:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_redirect_if_current_user!],
        [:if, self.method(:create_password_reset_request), {
          ok:    [self.method(:handle_success)],
          error: [self.method(:handler_error)],
        },],
      ],
      ctx:  { router_request: router_request },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|password_reset_request|create',
    aliases: ['web|users|password_reset_request|create'],
    target:  self.method(:endpoint),
  )

  def self.create_password_reset_request(router_request:)
    Kit::Organizer.call(
      list: [
        Kit::Auth::Actions::Users::RequestPasswordReset,
      ],
      ctx:  {
        router_request: router_request,
        email:          router_request.params[:email],
      },
    )
  end

  def self.handle_success(router_request:)
    Kit::Router::Controllers::Http.redirect_to(
      location: Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|users|password_reset_request|after'),
      notice:   I18n.t('kit.auth.notifications.password_reset_request.success', email: router_request.params[:email]),
    )
  end

  def self.handler_error(router_request:, errors:)
    model = router_request.params.slice(:email)

    Kit::Router::Controllers::Http.render(
      router_request: router_request,
      component:      Kit::Auth::Components::Pages::Users::PasswordResetRequest::NewComponent,
      params:         {
        model:       model,
        csrf_token:  router_request.adapters[:http_rails][:csrf_token],
        errors_list: errors,
      },
    )
  end

end
