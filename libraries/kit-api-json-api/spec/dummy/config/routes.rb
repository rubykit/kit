require 'kit_api_json_api'

Rails.application.routes.draw do

  list_api = [
    #{ id: 'api|users|show',     path: '/api/users/:resource_id',    verb: :get },
    { id: 'specs|api|users|index',    path: '/specs_api/users',                 verb: :get },

    #{ id: 'api|posts|show',     path: '/api/posts/:resource_id',    verb: :get },
    #{ id: 'api|posts|index',    path: '/api/posts',                 verb: :get },

    #{ id: 'api|comments|show',  path: '/api/comments/:resource_id', verb: :get },
    #{ id: 'api|comments|index', path: '/api/comments',              verb: :get },
  ]

  list_api.each do |entry|
    entry.merge!({
      rails_endpoint_wrapper: [::ApiController, :route],
    })
  end

  Kit::Router::Services::Adapters::Http::Rails::Routes.mount_http_targets(
    rails_router_context: self,
    list:                 list_api,
  )

end
