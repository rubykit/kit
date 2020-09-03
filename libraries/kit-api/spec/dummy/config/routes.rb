require 'kit_api'

Rails.application.routes.draw do

  list_api = [
    { id: 'specs|api|author|index',     path: '/dummy_app/json_api/authors',                   verb: :get },
    { id: 'specs|api|author|show',      path: '/dummy_app/json_api/authors/:resource_id',      verb: :get },

    { id: 'specs|api|book|index',       path: '/dummy_app/json_api/books',                     verb: :get },
    { id: 'specs|api|book|show',        path: '/dummy_app/json_api/books/:resource_id',        verb: :get },

    { id: 'specs|api|book_store|index', path: '/dummy_app/json_api/book_stores',               verb: :get },
    { id: 'specs|api|book_store|show',  path: '/dummy_app/json_api/book_stores/:resource_id',  verb: :get },

    { id: 'specs|api|chapter|index',    path: '/dummy_app/json_api/chapters',                  verb: :get },
    { id: 'specs|api|chapter|show',     path: '/dummy_app/json_api/chapters/:resource_id',     verb: :get },

    { id: 'specs|api|photo|index',      path: '/dummy_app/json_api/photos',                    verb: :get },
    { id: 'specs|api|photo|show',       path: '/dummy_app/json_api/photos/:resource_id',       verb: :get },

    { id: 'specs|api|serie|index',      path: '/dummy_app/json_api/series',                    verb: :get },
    { id: 'specs|api|serie|show',       path: '/dummy_app/json_api/series/:resource_id',       verb: :get },

    { id: 'specs|api|store|index',      path: '/dummy_app/json_api/stores',                    verb: :get },
    { id: 'specs|api|store|show',       path: '/dummy_app/json_api/stores/:resource_id',       verb: :get },
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
