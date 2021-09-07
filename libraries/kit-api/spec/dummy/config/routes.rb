require 'kit_api'

Rails.application.routes.draw do

  endpoints = ->(resource_singular:, resource_plural:) do
    [
      { id: "specs|api|#{ resource_singular }|index",  path: "/dummy_app/json_api/#{ resource_plural }",              verb: :get    },
      { id: "specs|api|#{ resource_singular }|show",   path: "/dummy_app/json_api/#{ resource_plural }/:resource_id", verb: :get    },
      { id: "specs|api|#{ resource_singular }|create", path: "/dummy_app/json_api/#{ resource_plural }",              verb: :post   },
      { id: "specs|api|#{ resource_singular }|update", path: "/dummy_app/json_api/#{ resource_plural }/:resource_id", verb: :patch  },
      { id: "specs|api|#{ resource_singular }|delete", path: "/dummy_app/json_api/#{ resource_plural }/:resource_id", verb: :delete },
    ]
  end

  list_api = {
    authors:     :author,
    books:       :book,
    book_stores: :book_store,
    chapters:    :chapter,
    photos:      :photo,
    series:      :serie,
    stores:      :store,
  }

  list_api.each do |k, v|
    list_api[k] = endpoints.call(resource_plural: k, resource_singular: v)
  end

  list_api.each do |namespace, mountpoints|
    mountpoints.each do |mountpoint|
      mountpoint.merge!({
        rails_endpoint_wrapper: [::ApiController, :route],
        namespace:              [:specs_api, namespace],
      })
    end

    Kit::Router::Adapters::HttpRails::Routes.mount_http_targets(
      rails_router_context: self,
      list:                 mountpoints,
    )
  end

end
