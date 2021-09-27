module Kit::Auth::Actions::Applications::LoadWeb

  def self.call(**)
    uid         = 'webapp'
    application = Kit::Auth::Models::Read::Application.find_by(uid: uid)

    if application
      [:ok, application: application]
    else
      [:error, detail: "Could not find `#{ uid }` application"]
    end
  end

end
