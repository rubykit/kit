module Kit::Auth::Controllers::Web::Users::ResetPassword
  module Edit

    def self.endpoint(router_request:)
      Kit::Organizer.call({
        ctx:  { router_request: router_request },
        list: [
          :web_require_current_user!,
          # TODO: fix this explicit dependency, not sure how?
          ->(ctx) { Kit::Auth::Controllers::WebController.redirect_if_missing_scope!(router_request: ctx[:router_request], scope: 'update_user_secret') },
          self.method(:render_view),
        ],
      })
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_auth|web|users|reset_password|edit',
      aliases: ['web|users|reset_password|edit'],
      target:  self.method(:endpoint),
    })

    def self.render_view(router_request:)
      model = { password: nil, password_confirmation: nil }

      Kit::Router::Controllers::Http.render(
        component: Kit::Auth::Components::Pages::Users::ResetPassword::Edit,
        params:    {
          model:      model,
          csrf_token: router_request.http[:csrf_token],
        },
      )
    end

  end
end
