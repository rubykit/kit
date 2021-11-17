class Kit::Auth::Models::Write::RequestMetadata < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::RequestMetadata

  belongs_to :user,
    class_name: 'Kit::Auth::Models::Write::User',
    optional:   true

  has_many   :request_metadata_links,
    class_name: 'Kit::Auth::Models::Write::RequestMetadataLink'

end
