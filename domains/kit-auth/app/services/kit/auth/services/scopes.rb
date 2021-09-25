module Kit::Auth::Services::Scopes

  # TODO: create a store for scopes?

  # Can use admin interface
  USER_ADMIN = :user_admin

  # Default privileges
  USER_DEFAULT = :user_default

  # ALlow email confirmation
  USER_EMAIL_CONFIRMATION = :user_email_confirmation

  # Allow to update password
  USER_PASSWORD_UPDATE = :user_password_update

  # Allow exchange for a USER_DEFAULT token
  USER_SIGN_IN = :user_sign_in

  # List of all scopes
  ALL = [
    USER_ADMIN,
    USER_DEFAULT,
    USER_EMAIL_CONFIRMATION,
    USER_PASSWORD_UPDATE,
    USER_SIGN_IN,
  ]

end
