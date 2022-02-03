module Kit::Auth::Endpoints::Events::Users::EmailConfirmed

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_email_id: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        self.method(:load_user_email!),
        ->(router_conn:) { [:ok, emitted_at: router_conn.request[:params][:emitted_at]] },
        self.method(:persist_event),
      ],
      ctx:  {
        router_conn: router_conn,
      },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|auth|email_confirmation|confirmed',
    target:  self.method(:endpoint),
    aliases: ['event|users|auth|email_confirmation|confirmed'],
  )

  def self.load_user_email!(router_conn:)
    user_email_id = router_conn.request[:params][:user_email_id]
    user_email    = Kit::Auth::Models::Read::UserEmail.find_by!(id: user_email_id)

    [:ok, user_email: user_email]
  end

  def self.persist_event(user_email:, emitted_at: nil)
    Kit::Events::Services::Event.persist_event(
      name: 'users|auth|email_confirmation|confirmed',
      data: {
        user_id:       user_email.user_id,
        user_email_id: user_email.id,
        email:         user_email.email,
      }.merge(emitted_at ? { emitted_at: emitted_at } : {}),
    )
  end

end
