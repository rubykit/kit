#require 'sidekiq/web'

Rails.application.routes.draw do

  Kit::Router::Services::Router.finalize_endpoints

  args_web = {
    context:                self,
    rails_endpoint_wrapper: ::Kit::Auth::DummyAppContainer::Controllers::WebController,
  }

  args_api = {
    context:                self,
    rails_endpoint_wrapper: ::Kit::Auth::DummyAppContainer::Controllers::ApiController,
  }

  # Domain routes --------------------------------------------------------------

  #mount Kit::Auth::Engine => '/'

  Kit::Auth::Services::Web::Routing.mount_routes_http_web(**args_web)

  # Dummy app routes -----------------------------------------------------------

  list_local = [
    { route_id: 'web|home|signed_out', path: '/',     verb: :get },
    { route_id: 'web|home|signed_in',  path: '/home', verb: :get },
  ]

  Kit::Router::Adapters::HttpRails::Routes.mount_rails_targets(rails_router_context: self, list: list_local)

  Kit::Auth::DummyApp::Services::Routing.mount_routes_http_web(**args_web)
  Kit::Auth::DummyApp::Services::Routing.mount_routes_http_api_jsonapi(**args_api)

  # ----------------------------------------------------------------------------
  # Mailer adapter

  Kit::Router::Adapters::MailerRails.default_mailer_adapter = {
    mailer_class:  ::ApplicationMailer,
    mailer_method: :default_email,
  }

  # ----------------------------------------------------------------------------
  # Async adapter

  Kit::Router::Adapters::AsyncRails.default_job_adapter = ApplicationJob

  # ----------------------------------------------------------------------------
  # Admin

  scope path: 'admin', as: 'admin' do
    ActiveAdmin.routes(self)
  end

  #mount Sidekiq::Web => '/sidekiq'

end
