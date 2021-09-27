class Kit::Auth::Models::Read::Application < Kit::Auth::Models::ReadRecord

  include Kit::Auth::Models::Base::Application

  has_many :user_access_tokens,
    class_name:  'Kit::Auth::Models::Read::UserSecret',
    foreign_key: 'application_id'

end
