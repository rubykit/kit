class Kit::Domain::Models::Write::RequestMetadata < Kit::Domain::Models::WriteRecord

  include Kit::Domain::Models::Base::RequestMetadata

  has_many   :request_metadata_links,
    class_name: 'Kit::Domain::Models::Write::RequestMetadataLink'

end
