module Kit::Auth::Actions::Users::RequestSignInLink

  def self.call(router_conn:, email:)
    Kit::Organizer.call(
      list: [
        #Kit::Auth::Services::Contracts::Email.method(:validate),
        Kit::Auth::Actions::RequestMetadata::Create,
        self.method(:send_event),
      ],
      ctx:  {
        router_conn: router_conn,
        email:       email,
        user:        nil,
      },
    )
  end

  def self.send_event(email:, request_metadata:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|users|sign_in_link_request',
      adapter_name: :async,
      params:       {
        email:            email,
        request_metadata: request_metadata,
      },
    )
  end

end