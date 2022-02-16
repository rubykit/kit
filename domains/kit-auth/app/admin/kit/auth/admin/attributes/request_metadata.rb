class Kit::Auth::Admin::Attributes::RequestMetadata < Kit::Domain::Admin::Attributes::RequestMetadata

  def self.all
    super.merge(
      user: :model_verbose,
    )
  end

  def self.index
    super.merge(
      user: :model_verbose,
    )
  end

end
