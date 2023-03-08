module Kit::Auth::Endpoints::Events::Users::SignIn

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Router::Contracts

  contract Ct::Hash[router_conn: Ct::RouterConn[params: Ct::Hash[user_id: Ct::NotNil, sign_in_method: Ct::NotNil]]]
  def self.endpoint(router_conn:)
    Kit::Organizer.call(
      list: [
        self.method(:load_from_params),
        self.method(:persist_event),
      ],
      ctx:  { router_conn: router_conn },
    )
  end

  def self.register_endpoint
    Kit::Router::Services::Router.register(
      uid:     'kit_auth|event|users|auth|sign_in',
      target:  self.method(:endpoint),
      aliases: ['event|users|auth|sign_in'],
    )
  end

  def self.load_from_params(router_conn:)
    params = router_conn.request[:params]

    [:ok, {
      user_id:        params[:user_id],
      sign_in_method: params[:sign_in_method],
      emitted_at:     params[:emitted_at],
    },]
  end

  def self.persist_event(user_id:, sign_in_method:, emitted_at: nil)
    Kit::Domain::Services::Event.persist_event(
      name:       'users|auth|sign_in',
      data:       {
        user_id: user_id,
        method:  sign_in_method,
      },
      emitted_at: emitted_at,
    )
  end

end
