module Kit::Auth::Endpoints::Web::Users::Settings::Devices::Index

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_require_current_user!],
        self.method(:list),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|web|authorization_tokens|index',
    aliases: ['web|authorization_tokens|index'],
    target:  self.method(:endpoint),
  )

  def self.list(router_conn:)
    list = Kit::Auth::Models::Read::OauthAccessToken
      .where('revoked_at IS NULL')
      .where("(created_at + expires_in * INTERVAL '1 second') > ?", DateTime.now)
      .where(resource_owner_id: router_conn.metadata[:current_user].id)
      .preload(:last_request_metadata)
      .load

    list = list.map do |model|
      request_metadata = model.last_request_metadata
      country          = nil

      if request_metadata
        country = Kit::Auth::Models::Read::IpGeolocation
          .where('ip_start <= ?', request_metadata.ip.to_s)
          .where('ip_end   >= ?', request_metadata.ip.to_s)
          .first
          &.country
      end

      {
        oauth_access_token: model.attributes&.symbolize_keys,
        request_metadata:   request_metadata&.attributes&.symbolize_keys,
        country:            country&.attributes&.symbolize_keys,
      }
    end

    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:      Kit::Auth::Components::Pages::Users::Settings::Devices::IndexComponent,
      params:         {
        list: list,
      },
    )
  end

end
