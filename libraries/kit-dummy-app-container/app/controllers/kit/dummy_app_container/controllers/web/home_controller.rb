class Kit::DummyAppContainer::Controllers::Web::HomeController < Kit::DummyAppContainer::Controllers::WebController # rubocop:disable Style/Documentation

  if (layout_name = KIT_APP_PATHS['GEM_SPEC_VIEW_LAYOUT'])
    layout layout_name
  end

  # Note: just in case we are using a plain Rails app
  if defined?(Kit::Router)
    Kit::Router::Services::Router.register_without_target(
      uid:     'kit-dummy-container|web|home',
      aliases: ['app|home'],
      types:   {
        [:http, :rails] => {
          target: [self, :index],
        },
      },
    )
  end

  def index
    render
  end

end
