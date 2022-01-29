class Kit::Auth::Admin::Tables::Application < Kit::ActiveAdmin::Table

  def self.attributes_for_all
    base_attributes.merge(
      name:         :code,
      created_at:   nil,
      updated_at:   nil,
      uid:          :code,
      scopes:       :code,
      confidential: nil,
    )
  end

  def self.attributes_for_index
    attributes_for_all
  end

  def self.attributes_for_list
    attributes_for_index
  end

  def self.attributes_for_show
    attributes_for_all
  end

end
