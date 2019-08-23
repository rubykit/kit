module Kit::Auth::Actions::OauthApplications::LoadApi

  def self.call(*)
    uid         = 'api'
    application = Kit::Auth::Models::Read::OauthApplication.find_by(uid: uid)

    if application
      [:ok, oauth_application: application]
    else
      [:error, detail: "Could not find `#{uid}` application"]
    end
  end

end