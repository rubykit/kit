class ::Web::HomeController < ::WebController

  Kit::Router::Services::Router.register_without_target({
    uid:     'kit-auth|spec_app|home',
    aliases: [
      'app|home',
      'web|users|after_sign_in',
      'web|users|after_sign_up',
    ],
    types: {
      [:http, :rails] => {
        target: [self, :index],
      },
    },
  })

  def index
    render
  end

end