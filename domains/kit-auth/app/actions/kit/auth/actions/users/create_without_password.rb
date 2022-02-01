module Kit::Auth::Actions::Users::CreateWithoutPassword

  def self.call(email:, sign_up_method:)
    status, ctx = Kit::Organizer.call(
      list: [
        self.method(:persist_user),
        self.method(:send_event),
      ],
      ctx:  {
        email:          email,
        sign_up_method: sign_up_method,
      },
    )

    if status == :error
      [:error, errors: ctx[:errors]]
    else
      [:ok, user: ctx[:user]]
    end
  end

  def self.persist_user(email:)
    begin
      user = Kit::Auth::Models::Write::User.create(
        email: email,
      )
    rescue ActiveRecord::RecordNotUnique
      return [:error, user: nil, errors: [{ attribute: :email, detail: 'This $attribute is already taken.' }]]
    end

    if user.persisted?
      [:ok, user: user]
    else
      [:error, user: nil, errors: user.errors]
    end
  end

  def self.send_event(user:, sign_up_method:)
    Kit::Router::Services::Adapters.cast(
      route_id:     'event|users|auth|sign_up',
      adapter_name: :async,
      params:       {
        user_id:        user.id,
        sign_up_method: sign_up_method,
      },
    )

    [:ok]
  end

end
