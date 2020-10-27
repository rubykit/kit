class ::Web::HomeController < ::WebController # rubocop:disable Style/Documentation

  if (layout_name = KIT_APP_PATHS['GEM_SPEC_VIEW_LAYOUT'])
    layout layout_name
  end

=begin
  Kit::Router::Services::Router.register_without_target({
    uid:     'app|home',
    aliases: [
      'web|users|after_sign_in',
      'web|users|after_sign_up',
    ],
    types: {
      [:http, :rails] => {
        target: [self, :index],
      },
    },
  })
=end

  def index
    render
  end

end
