class Kit::Auth::Models::Read::UserEmail < Kit::Auth::Models::ReadRecord

  include Kit::Auth::Models::Base::UserEmail

  def user
    @user ||= Kit::Auth::Models::Read::User.find(self.id)
  end

end
