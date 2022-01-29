Rails.application.routes.draw do

  # Endpoint declaration is considered over
  Kit::Router::Services::Router.finalize_endpoints

  # ----------------------------------------------------------------------------
  # Config

  # Mailer adapter
  Kit::Router::Adapters::MailerRails.default_mailer_adapter = {
    mailer_class:  ::ApplicationMailer,
    mailer_method: :default_email,
  }

  # Async adapter
  Kit::Router::Adapters::AsyncRails.default_job_adapter = ::ApplicationJob

  # Rails controller wrappers
  web_endpoint_wrapper = [::Kit::Auth::DummyAppContainer::Controllers::WebController, :route]
  api_endpoint_wrapper = [::Kit::Auth::DummyAppContainer::Controllers::ApiController, :route]

  # ----------------------------------------------------------------------------
  # Kit::Auth domain routes

  Kit::Auth::Services::Web::Routing.mount_routes_http_web(
    context:                self,
    rails_endpoint_wrapper: web_endpoint_wrapper,
  )

  # ----------------------------------------------------------------------------
  # Dummy app routes

  Kit::Auth::DummyApp::Services::Routing.mount_routes_http_rails(
    context:                self,
  )

  Kit::Auth::DummyApp::Services::Routing.mount_routes_http_web(
    context:                self,
    rails_endpoint_wrapper: web_endpoint_wrapper,
  )

  if Rails.env.test? || Rails.env.development?
    Kit::Domain::Services::Specs::Routing.mount_routes_http_web(
      context:                self,
      rails_endpoint_wrapper: web_endpoint_wrapper,
    )
  end

  if Rails.env.test?
    Kit::Auth::DummyApp::Services::Routing.mount_routes_http_web_aliases(
      context:                self,
      rails_endpoint_wrapper: web_endpoint_wrapper,
    )
  end

  Kit::Auth::DummyApp::Services::Routing.mount_routes_http_api_jsonapi(
    context:                self,
    rails_endpoint_wrapper: api_endpoint_wrapper,
  )

  # ----------------------------------------------------------------------------
  # Admin

  scope path: 'admin', as: 'admin' do
    Kit::Auth::Admin.register_namespace
    Kit::Auth::Admin.register_resources
    Kit::Auth::Admin.setup_tables
    ActiveAdmin.routes(self)
  end

end
