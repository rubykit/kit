class Kit::Auth::Models::Write::RequestMetadataLink < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::RequestMetadataLink

  belongs_to :request_metadata,
    class_name: 'Kit::Auth::Models::Write::RequestMetadata'

  belongs_to :target_object, polymorphic: true

end
