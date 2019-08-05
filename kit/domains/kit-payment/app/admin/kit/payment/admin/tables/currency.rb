require_relative 'base_table'

class Kit::Payment::Admin::Tables::Currency < Kit::Payment::Admin::Tables::BaseTable

  def attributes_for_all
    {
      id:            :model_id,
      iso4217_alpha: :code,
      name:          :code,
      minor_unit:    :code,
    }
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