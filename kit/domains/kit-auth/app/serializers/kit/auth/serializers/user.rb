module Kit::Auth::Serializers
  class User < JSONAPI::Serializable::Resource
    type 'users'

    attributes :created_at, :confirmed_at

    has_many :oauth_access_tokens do
      link :related do
        Kit::Router::Services::Router.url(id: 'api|authorization_tokens|index', params: { user_id: @object.resource_owner_id })
      end
    end

    link :self do
      Kit::Router::Services::Router.url(id: 'api|users|show', params: { resource_id: @object.id })
    end

  end
end