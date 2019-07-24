require 'bcrypt'
require 'dry-validation'

class Kit::Auth::Actions::Users::CreateUserWithPassword
  include Contracts

  Contract Hash => [Symbol, KeywordArgs[user: Any, errors: Any]]
  def self.call(email:, password:, password_confirmation:, **)
    status, ctx = Organizer.call({
      list: [
        self.method(:validate_password),
        self.method(:validate_email),
        Kit::Auth::Services::Password.method(:generate_hashed_secret),
        self.method(:persist_user),
        self.method(:fire_user_created_event),
      ],
      ctx: {
        email: email,
        password: password,
        password_confirmation: password_confirmation,
      },
    })

    if ctx[:errors]
      [:error, user: nil, errors: ctx[:errors]]
    else
      [:ok, user: ctx[:user]]
    end
  end

  def self.validate_password(password:, password_confirmation:)
    res = Kit::Auth::Services::Contracts::Password.new.call({
      password: password,
      password_confirmation: password_confirmation,
    })

    if res.errors.count > 0
      [:error, errors: res.errors.to_h]
    else
      [:ok]
    end
  end

  def self.validate_email(email:)
    res = Kit::Auth::Services::Contracts::Email.new.call(email: email)

    if res.errors.count > 0
      [:error, errors: res.errors.to_h]
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
      return [:error, user: nil, errors: { email: ["is alreadky taken"] }]
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