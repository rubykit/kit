module Kit::Auth::Serializers
  class AccessToken < JSONAPI::Serializable::Resource
    type 'access_tokens'

    attributes :created_at, :scopes

    attribute :secret do
      @object.token
    end

    attribute :revoked do
      !!@object.revoked_at
    end

    attribute :type do
      @object.oauth_application.uid == 'api' ? 'api' : 'web'
    end

    attribute :expires_at do
      @object.created_at + @object.expires_in
    end

    belongs_to :user do
      link :related do
        Kit::Router::Services::Router.url(id: 'api|users|show', params: { resource_id: @object.resource_owner_id })
      end
    end

    link :self do
      Kit::Router::Services::Router.url(id: 'api|authorization_tokens|show', params: { resource_id: @object.id })
    end

  end
end