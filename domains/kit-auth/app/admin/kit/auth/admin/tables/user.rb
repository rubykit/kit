require_relative 'base_table'

class Kit::Auth::Admin::Tables::User < Kit::Auth::Admin::Tables::BaseTable

  def attributes_for_all
    base_attributes.merge(
      email:        :code,
      created_at:   nil,
      updated_at:   nil,
      confirmed_at: nil,
    )
  end

  def attributes_for_index
    attributes_for_all
  end

  def attributes_for_list
    attributes_for_index
  end

  def attributes_for_show
    attributes_for_all
  end

end
