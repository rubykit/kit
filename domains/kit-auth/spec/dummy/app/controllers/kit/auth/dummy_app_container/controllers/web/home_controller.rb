class Kit::Auth::DummyAppContainer::Controllers::Web::HomeController < Kit::Auth::DummyAppContainer::Controllers::WebController

  Kit::Router::Services::Router.register_without_target(
    uid:     'kit-auth|spec_app|web|home',
    aliases: {
      'web|home' => [
        'web|users|sign_in|after',
        'web|users|sign_up|after',
        'web|users|sign_out|after',
        'web|users|password_reset|after',
      ],
    },
    types:   {
      [:http, :rails] => {
        target: [self, :index],
      },
    },
  )

  def index
    render
  end

end
