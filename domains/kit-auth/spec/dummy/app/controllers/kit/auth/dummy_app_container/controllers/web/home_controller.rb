class Kit::Auth::DummyAppContainer::Controllers::Web::HomeController < Kit::Auth::DummyAppContainer::Controllers::WebController

  def index_signed_in
    render
  end

  Kit::Router::Services::Router.register_without_target(
    uid:     'kit-auth|spec_app|web|home|signed_in',
    aliases: {
      'web|home|signed_in' => [
        'web|users|sign_in|after',
        'web|users|sign_up|after',
        'web|users|password_reset|after',
        'web|users|email_confirmation|after|signed_in',
      ],
    },
    types:   {
      [:http, :rails] => { target: [self, :index_signed_in], },
    },
  )

  # ----------------------------------------------------------------------------

  def index_signed_out
    render
  end

  Kit::Router::Services::Router.register_without_target(
    uid:     'kit-auth|spec_app|web|home|signed_out',
    aliases: {
      'web|home|signed_out' => [
        'web|home',
        'web|users|sign_out|after',
        'web|users|password_reset|after',
        'web|users|email_confirmation|after|signed_out',
      ],
    },
    types:   {
      [:http, :rails] => { target: [self, :index_signed_out], },
    },
  )

end
