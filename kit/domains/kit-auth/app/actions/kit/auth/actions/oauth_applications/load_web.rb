module Kit::Auth::Actions::OauthApplications::LoadWeb

  def self.call(user:, request:)
    uid = 'web'

    application = Kit::Auth::Models::Read::OauthApplication.find_by(uid: uid)

    if application
      [:ok, oauth_application: application]
    else
      [:error, detail: "Could not find `#{uid}` application"]
    end
  end

end