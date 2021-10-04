module Kit::Auth::Models::Base::UserEmail

  extend ActiveSupport::Concern

  included do
    self.table_name = 'users'

    acts_as_paranoid

    read_columns = [
      :id,
      :created_at,
    ]

    write_columns = [
      :updated_at,
      :deleted_at,
      :email,
      :email_confirmed_at,
    ]

    self.allowed_columns = write_columns + read_columns
  end

  def user_id
    self.id
  end

  def confirmed?
    !!self.email_confirmed_at
  end

end
