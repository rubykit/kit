module Kit::Auth::Actions::Applications::LoadApi

  def self.call(**)
    uid         = 'api'
    application = Kit::Auth::Models::Read::Application.find_by(uid: uid)

    if application
      [:ok, application: application]
    else
      [:error, detail: "Could not find `#{ uid }` application"]
    end
  end

end
