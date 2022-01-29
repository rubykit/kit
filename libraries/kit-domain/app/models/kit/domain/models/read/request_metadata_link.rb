class Kit::Domain::Models::Read::RequestMetadataLink < Kit::Domain::Models::ReadRecord

  include Kit::Domain::Models::Base::RequestMetadataLink

  belongs_to :request_metadata,
    class_name: 'Kit::Domain::Models::Read::RequestMetadata'

  belongs_to :target_object, polymorphic: true

end
