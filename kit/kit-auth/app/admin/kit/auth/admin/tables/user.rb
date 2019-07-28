require_relative 'base_table'

class Kit::Auth::Admin::Tables::User < Kit::Auth::Admin::Tables::BaseTable
#class Kit::Auth::KitAuthAdmin::Tables::User < Kit::Auth::KitAuthAdmin::Tables::BaseTable

  def attributes_for_all
    base_attributes.merge(
      email:              :code,
      #sign_in_count:      :code,
      #current_sign_in_at: nil,
      #current_sign_in_ip: :code,
      #last_sign_in_at:    nil,
      #last_sign_in_ip:    :code,
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