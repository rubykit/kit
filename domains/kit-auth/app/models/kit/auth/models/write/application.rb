class Kit::Auth::Models::Write::Application < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::Application

  has_many :user_access_tokens,
    class_name:  'Kit::Auth::Models::Write::UserSecret',
    foreign_key: 'application_id'

end
