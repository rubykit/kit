module Kit::Auth::Admin::OauthIdentity
end

ActiveAdmin.register Kit::Auth::Models::Read::OauthIdentity, as: 'OauthIdentity', namespace: :kit_auth do
  menu label: 'OAuthIdentity', parent: 'Auth'

  actions :all, except: [:new, :edit, :destroy]

  index do
    Kit::Auth::Admin::Tables::OauthIdentity.new(self).index
  end

  show do
    Kit::Auth::Admin::Tables::OauthIdentity.new(self).panel resource
  end

end
