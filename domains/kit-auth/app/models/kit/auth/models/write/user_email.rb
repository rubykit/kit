class Kit::Auth::Models::Write::UserEmail < Kit::Auth::Models::WriteRecord

  include Kit::Auth::Models::Base::UserEmail

  def user
    @user ||= Kit::Auth::Models::Write::User.find(self.id)
  end

end
