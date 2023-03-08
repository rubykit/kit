module Kit::Auth::Endpoints::Web::Users::Settings::Sessions::Index

  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        [:alias, :web_require_session_user!],
        self.method(:list),
        self.method(:render),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|web|settings|sessions|index',
      aliases: {
        'web|settings|sessions|index': [
          'web|settings|sessions',
        ],
      },
      target:  self.method(:endpoint),
    )
  end

  def self.list(router_conn:)
    # Note: currently has to be in write mode because of polymorphic relationship issue.
    list = Kit::Auth::Models::Write::UserSecret
      .where(category: 'access_token')
      .where(scopes: 'user_default')
      .where(revoked_at: nil)
      .where("(created_at + expires_in * INTERVAL '1 second') > ?", DateTime.now)
      .where(user_id: router_conn.metadata[:session_user].id)
      .order(created_at: :desc)
      .preload(:last_request_metadata)
      .load

    list = list.map do |model|
      request_metadata = model.last_request_metadata
      country          = nil

=begin
      if request_metadata
        country = Kit::Auth::Models::Read::IpGeolocation
          .where('ip_start <= ?', request_metadata.ip.to_s)
          .where('ip_end   >= ?', request_metadata.ip.to_s)
          .first
          &.country
      end
=end

      {
        access_token:     model.attributes&.symbolize_keys,
        request_metadata: request_metadata&.attributes&.symbolize_keys,
        country:          country&.attributes&.symbolize_keys,
      }
    end

    [:ok, list: list]
  end

  def self.render(router_conn:, list:)
    Kit::Domain::Endpoints::Http.render(
      router_conn: router_conn,
      component:   Kit::Auth::Components::Pages::Users::Settings::Sessions::IndexComponent,
      params:      {
        list: list,
      },
    )
  end

end
