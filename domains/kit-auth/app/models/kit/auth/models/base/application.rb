module Kit::Auth::Models::Base::Application

  extend ActiveSupport::Concern

  included do
    self.table_name = 'applications'

    acts_as_paranoid

    read_columns = [
      :id,
      :created_at,
    ]

    write_columns = [
      :updated_at,
      :deleted_at,

      :uid,
      :name,

      :scopes,
      :data,
    ]

    self.allowed_columns = write_columns + read_columns
  end

  def model_verbose_name
    "#{ model_log_name }|#{ name }"
  end

end
