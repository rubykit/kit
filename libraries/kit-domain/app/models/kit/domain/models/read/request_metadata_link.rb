class Kit::Auth::Models::Read::RequestMetadataLink < Kit::Auth::Models::ReadRecord

  include Kit::Auth::Models::Base::RequestMetadataLink

  belongs_to :request_metadata,
    class_name: 'Kit::Auth::Models::Read::RequestMetadata'

  belongs_to :target_object, polymorphic: true

end
