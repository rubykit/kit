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
        #@url_helpers.user_posts_url(@object.id)
      end
    end

    link :self do
      #@url_helpers.post_url(@object.id)
    end

  end
end