class Kit::Auth::Models::Read::UserSecret < Kit::Auth::Models::ReadRecord

  include Kit::Auth::Models::Base::UserSecret

  belongs_to :application,
    class_name:  'Kit::Auth::Models::Read::Application',
    foreign_key: 'application_id'

  belongs_to :user,
    class_name:  'Kit::Auth::Models::Read::User',
    foreign_key: 'user_id'

  belongs_to :last_request_metadata,
    class_name: 'Kit::Auth::Models::Read::RequestMetadata',
    optional:   true

end
