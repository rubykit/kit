module Kit::Auth::Controllers::Web::Users::ResetPassword
  module Edit

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
      uid:     'kit_auth|web|users|reset_password|edit',
      aliases: ['web|users|reset_password|edit'],
      target:  self.method(:endpoint),
    })

    def self.render_view(request:)
      model = { password: nil, password_confirmation: nil }

      Kit::Router::Controllers::Http.render(
        component: Kit::Auth::Components::Pages::Users::ResetPassword::Edit,
        params: {
          model:      model,
          csrf_token: request.http[:csrf_token],
        }
      )
    end

  end
end