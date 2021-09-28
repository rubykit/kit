class Kit::Auth::Models::Write::UserSecret < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::UserSecret

  belongs_to :application,
    class_name:  'Kit::Auth::Models::Write::Application',
    foreign_key: 'application_id'

  belongs_to :user,
    class_name:  'Kit::Auth::Models::Write::User',
    foreign_key: 'user_id'

  belongs_to :last_request_metadata,
    class_name: 'Kit::Auth::Models::Write::RequestMetadata',
    optional:   true

end