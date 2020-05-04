module Kit::Auth::Actions::Users::CreateWithPassword

  #Contract Hash => [Symbol, KeywordArgs[user: Any, errors: Any]]
  def self.call(email:, password:, password_confirmation:, email_confirmation: nil)
    status, ctx = Kit::Organizer.call({
      ctx: {
        email:                 email,
        email_confirmation:    email_confirmation,
        password:              password,
        password_confirmation: password_confirmation,
      },
      list: [
        self.method(:validate_email),
        self.method(:validate_password),
        Kit::Auth::Services::Password.method(:generate_hashed_secret),
        self.method(:persist_user),
        self.method(:fire_user_created_event),
      ],
    })

    if ctx[:errors]
      [:error, user: nil, errors: ctx[:errors]]
    else
      [:ok, user: ctx[:user]]
    end
  end

  def self.validate_password(password:, password_confirmation:)
    res = Kit::Auth::Services::Contracts::Password.new.call({
      password:              password,
      password_confirmation: password_confirmation,
    })

    if res.errors.count > 0
      [:error, Kit::Error.from_contract(res)]
    else
      [:ok]
    end
  end

  def self.validate_email(email:, email_confirmation:)
    res = Kit::Auth::Services::Contracts::EmailSignup.new.call({
      email:              email,
      email_confirmation: email_confirmation,
    })

    if res.errors.count > 0
      [:error, errors: Kit::Error.from_contract(res)]
    else
      [:ok]
    end
  end

  def self.persist_user(email:, hashed_secret:)
    begin
      user  = Kit::Auth::Models::Write::User.create({
        email:         email,
        hashed_secret: hashed_secret,
      })
    rescue ActiveRecord::RecordNotUnique
      return [:error, user: nil, errors: { attribute: :email, detail: "$attribute is alreadky taken." }]
    end

    if user.persisted?
      [:ok, user: user]
    else
      [:error, user: nil, errors: user.errors]
    end
  end

  def self.fire_user_created_event(user:)
    puts "Fire user_created event"
    [:ok]
  end

end