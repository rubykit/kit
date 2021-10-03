require_relative 'base_table'

class Kit::Auth::Admin::Tables::Application < Kit::Auth::Admin::Tables::BaseTable

  def attributes_for_all
    base_attributes.merge(
      name:         :code,
      created_at:   nil,
      updated_at:   nil,
      uid:          :code,
      scopes:       :code,
      confidential: nil,
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
