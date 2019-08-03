::ActiveAdmin.register Kit::Auth::Models::Read::OauthIdentity, as: 'OauthIdentity', namespace: :kit_auth_admin do
  menu label: 'OAuthIdentity', parent: 'OAuth'

  actions :all, except: [:new, :edit, :destroy]

  index do
    Kit::Auth::Admin::Tables::OauthIdentity.new(self).index
  end

  show do
    Kit::Auth::Admin::Tables::OauthIdentity.new(self).panel resource
  end

end
