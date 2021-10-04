module Kit::Events::Models::Base::Event
  extend ActiveSupport::Concern

  included do
    self.table_name = 'events'

    write_columns = [
      :id,
      :created_at,
      :deleted_at,

      :name,
      :data,
      :metadata,
    ]

    read_columns = []

    self.allowed_columns = write_columns + read_columns

    acts_as_paranoid

    store_accessor :data
    store_accessor :metadata
  end

end
