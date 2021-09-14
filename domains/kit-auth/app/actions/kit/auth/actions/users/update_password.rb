module Kit::Auth::Actions::Users::UpdatePassword

  def self.call(user:, password:, password_confirmation:)
    _status, ctx = Kit::Organizer.call(
      list: [
        #self.method(:validate_password),
        Kit::Auth::Services::Password.method(:generate_hashed_secret),
        self.method(:update_user),
        self.method(:send_event),
      ],
      ctx:  {
        user:                  user,
        password:              password,
        password_confirmation: password_confirmation,
      },
    )

    if ctx[:errors]
      [:error, user: nil, errors: ctx[:errors]]
    else
      [:ok, user: ctx[:user]]
    end
  end

  def self.validate_password(password:, password_confirmation:)
    res = Kit::Auth::Services::Contracts::Password.new.call(
      password:              password,
      password_confirmation: password_confirmation,
    )

    if res.errors.count > 0
      [:error, Kit::Error.from_contract(res)]
    else
      [:ok]
    end
  end

  def self.update_user(user:, hashed_secret:)
    writeable_model = Kit::Auth::Models::Write::User.find(user.id)

    writeable_model.update!({
      hashed_secret: hashed_secret,
    })

    if writeable_model.persisted?
      [:ok, user: user.reload]
    else
      [:error, user: nil, errors: writeable_model.errors]
    end
  end

  def self.send_event(user:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|users|password_reset',
      adapter_name: :async,
      params:       {
        user: user,
      },
    )

    [:ok]
  end

end
