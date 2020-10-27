require 'kit/engine'
require 'kit/domain'

# Rails engine for `Kit::Auth` domain.
class Kit::Auth::Engine < ::Rails::Engine

  ::Kit::Engine.config_engine(
    context:   self,
    namespace: Kit::Auth,
    file:      __FILE__,
  )

  ::Kit::Domain.config_domain(
    context:   self,
    namespace: Kit::Auth,
    file:      __FILE__,
  )

  initializer 'kit-auth.view_helpers' do
    ActionView::Base.include Kit::Auth::Helpers::ViewHelpers
  end

=begin
  initializer "web_app.assets.precompile" do |app|
    app.config.assets.precompile += %w( kit-active-admin.js kit-active-admin.css )
  end
=end

end
