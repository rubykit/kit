module Kit::Auth::Models
  class User < WriteAccessRecord
    acts_as_paranoid

    devise(*[
      :database_authenticatable,
      :registerable,
      :recoverable,
      :rememberable,
      :validatable,
      #:confirmable,
      #:lockable,
      #:timeoutable,
      #:trackable,
      #:omniauthable,
    ])
  end
end
