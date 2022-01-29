class Kit::Domain::Models::Write::RequestMetadataLink < Kit::Domain::Models::WriteRecord

  include Kit::Domain::Models::Base::RequestMetadataLink

  belongs_to :request_metadata,
    class_name: 'Kit::Domain::Models::Write::RequestMetadata'

  belongs_to :target_object, polymorphic: true

end
