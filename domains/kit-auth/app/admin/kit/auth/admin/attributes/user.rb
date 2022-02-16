class Kit::Auth::Admin::Attributes::User < Kit::Admin::Attributes

  def self.all
    base_attributes.merge(
      email:        :code,
      created_at:   nil,
      updated_at:   nil,
      confirmed_at: nil,
    )
  end

end
