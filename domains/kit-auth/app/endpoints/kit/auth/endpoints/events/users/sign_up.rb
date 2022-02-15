module Kit::Auth::Endpoints::Events::Users::SignUp

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_id: Ct::NotNil, sign_up_method: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      safe: true,
      list: [
        self.method(:load_from_params),
        self.method(:load_user!),
        self.method(:persist_event),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  Kit::Router::Services::Router.register(
    uid:     'kit_auth|event|users|auth|sign_up',
    target:  self.method(:endpoint),
    aliases: ['event|users|auth|sign_up'],
  )

  def self.load_from_params(router_conn:)
    params = router_conn.request[:params]

    [:ok, {
      user_id:        params[:user_id],
      sign_up_method: params[:sign_up_method],
      emitted_at:     params[:emitted_at],
    },]
  end

  def self.load_user!(user_id:)
    [:ok, user: Kit::Auth::Models::Read::User.find_by!(id: user_id)]
  end

  def self.persist_event(user:, sign_up_method:, emitted_at: nil)
    Kit::Domain::Services::Event.persist_event(
      name: 'users|auth|sign_up',
      data: {
        user_id: user.id,
        method:  sign_up_method,
      }.merge(emitted_at ? { emitted_at: emitted_at } : {}),
    )

    [:ok]
  end

end
