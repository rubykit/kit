module Kit::Auth::Endpoints::Web::Users::PasswordReset::Edit

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_require_current_user!],
        [:alias, :web_redirect_if_missing_scope!],
        self.method(:render_view),
      ],
      ctx:  {
        router_conn: router_conn,
        scope:       :user_update_password,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|users|password_reset|edit',
    aliases: ['web|users|password_reset|edit'],
    target:  self.method(:endpoint),
  )

  def self.render_view(router_conn:)
    model = { password: nil, password_confirmation: nil }

    Kit::Router::Controllers::Http.render(
      router_conn: router_conn,
      component:   Kit::Auth::Components::Pages::Users::PasswordReset::EditComponent,
      params:      {
        model:        model,
        access_token: router_conn.request[:params][:access_token],
        csrf_token:   router_conn.request[:http][:csrf_token],
      },
    )
  end

end
