class Kit::Auth::Admin::Tables::User < Kit::ActiveAdmin::Table

  def self.attributes_for_all
    base_attributes.merge(
      email:        :code,
      created_at:   nil,
      updated_at:   nil,
      confirmed_at: nil,
    )
  end

end
