module Kit::Auth::Models::Base::UserEmail

  extend ActiveSupport::Concern

  included do
    self.table_name = 'users'

    acts_as_paranoid

    read_columns = [
      :id,
      :created_at,

      :email,
    ]

    write_columns = [
      :updated_at,
      :deleted_at,
      :email,
      :email_confirmed_at,
    ]

    self.whitelisted_columns = write_columns + read_columns
  end

  def confirmed?
    !!self.email_confirmed_at
  end

end
