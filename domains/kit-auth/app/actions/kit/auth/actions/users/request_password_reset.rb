module Kit::Auth::Actions::Users::RequestPasswordReset

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
      route_id:     'event|users|auth|password_reset_request',
      adapter_name: :async,
      params:       {
        email:               email,
        request_metadata_id: request_metadata.id,
      },
    )
  end

end
