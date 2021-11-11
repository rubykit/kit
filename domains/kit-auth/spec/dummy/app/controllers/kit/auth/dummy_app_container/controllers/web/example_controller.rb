# Show how to register a classic Rails endpoint with Kit::Router.
class Kit::Auth::DummyAppContainer::Controllers::Web::ExampleController < Kit::Auth::DummyAppContainer::Controllers::WebController

  def example_rails_endpoint
    render
  end

  Kit::Router::Services::Router.register_without_target(
    uid:     'kit-auth|dummy_app|web|rails_example',
    aliases: ['web|rails_example'],
    types:   {
      [:http, :rails] => { target: [self, :example_rails_endpoint], },
    },
  )

end
