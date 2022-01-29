class Kit::Domain::Models::Read::RequestMetadata < Kit::Domain::Models::ReadRecord

  include Kit::Domain::Models::Base::RequestMetadata

  has_many   :request_metadata_links,
    class_name: 'Kit::Domain::Models::Read::RequestMetadataLink'

end
