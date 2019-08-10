module Kit::Auth::Serializers
  class User < JSONAPI::Serializable::Resource
    type 'users'

    attributes :created_at, :confirmed_at

    has_many :oauth_access_tokens do
      link :related do
        #@url_helpers.user_posts_url(@object.id)
      end
    end

    link :self do
      #@url_helpers.post_url(@object.id)
    end

  end
end