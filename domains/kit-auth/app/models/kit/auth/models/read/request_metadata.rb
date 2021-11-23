class Kit::Auth::Models::Read::RequestMetadata < Kit::Auth::Models::ReadRecord

  include Kit::Auth::Models::Base::RequestMetadata

  belongs_to :user,
    class_name: 'Kit::Auth::Models::Read::User'

  has_many   :request_metadata_links,
    class_name: 'Kit::Auth::Models::Read::RequestMetadataLink'

end
