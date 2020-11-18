require 'kit_api'

Rails.application.routes.draw do

  list_api = {
    authors:     [
      { id: 'specs|api|author|index',      path: '/dummy_app/json_api/authors',                   verb: :get  },
      { id: 'specs|api|author|show',       path: '/dummy_app/json_api/authors/:resource_id',      verb: :get  },
      { id: 'specs|api|author|create',     path: '/dummy_app/json_api/authors',                   verb: :post },
      { id: 'specs|api|author|update',     path: '/dummy_app/json_api/authors/:resource_id',      verb: :patch },
      { id: 'specs|api|author|delete',     path: '/dummy_app/json_api/authors/:resource_id',      verb: :delete },
    ],

    books:       [
      { id: 'specs|api|book|index',        path: '/dummy_app/json_api/books',                     verb: :get },
      { id: 'specs|api|book|show',         path: '/dummy_app/json_api/books/:resource_id',        verb: :get },
    ],

    book_stores: [
      { id: 'specs|api|book_store|index',  path: '/dummy_app/json_api/book_stores',               verb: :get },
      { id: 'specs|api|book_store|show',   path: '/dummy_app/json_api/book_stores/:resource_id',  verb: :get },
      #{ id: 'specs|api|book_store|delete', path: '/dummy_app/json_api/book_stores',              verb: :delete, namespace: [] },
    ],

    chapters:    [
      { id: 'specs|api|chapter|index',     path: '/dummy_app/json_api/chapters',                  verb: :get },
      { id: 'specs|api|chapter|show',      path: '/dummy_app/json_api/chapters/:resource_id',     verb: :get },
    ],

    photos:      [
      { id: 'specs|api|photo|index',       path: '/dummy_app/json_api/photos',                    verb: :get },
      { id: 'specs|api|photo|show',        path: '/dummy_app/json_api/photos/:resource_id',       verb: :get },
    ],

    series:      [
      { id: 'specs|api|serie|index',       path: '/dummy_app/json_api/series',                    verb: :get },
      { id: 'specs|api|serie|show',        path: '/dummy_app/json_api/series/:resource_id',       verb: :get },
    ],

    stores:      [
      { id: 'specs|api|store|index',       path: '/dummy_app/json_api/stores',                    verb: :get },
      { id: 'specs|api|store|show',        path: '/dummy_app/json_api/stores/:resource_id',       verb: :get },
    ],
  }

  list_api.each do |namespace, mountpoints|
    mountpoints.each do |mountpoint|
      mountpoint.merge!({
        rails_endpoint_wrapper: [::ApiController, :route],
        namespace:              [:specs_api, namespace],
      })
    end

    Kit::Router::Services::Adapters::Http::Rails::Routes.mount_http_targets(
      rails_router_context: self,
      list:                 mountpoints,
    )
  end

end
