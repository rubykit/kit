class Kit::Auth::Models::Write::UserSecret < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::UserSecret

  belongs_to :application,
    class_name:  'Kit::Auth::Models::Write::Application',
    foreign_key: 'application_id'

  belongs_to :user,
    class_name:  'Kit::Auth::Models::Write::User',
    foreign_key: 'user_id'

  has_one :last_request_metadata_link, -> { where(category: 'last') },
    class_name: 'Kit::Domain::Models::Write::RequestMetadataLink',
    as:         :target_object

  has_one :last_request_metadata,
    through:     :last_request_metadata_link,
    source:      :request_metadata,
    class_name:  'Kit::Auth::Models::Write::RequestMetadata',
    foreign_key: 'request_metadata_id'

end
