module Kit::Auth::Admin::UserSecret
end

=begin
Kit::Auth::Admin.register Kit::Auth::Models::Read::UserSecret, as: 'UserSecret', namespace: :kit_auth_admin do
  menu label: 'OAuthAccessToken', parent: 'OAuth'

  actions :all, except: [:new, :edit, :destroy]

  index do
    Kit::Auth::Admin::Tables::UserSecret.new(self).index
  end

  show do
    Kit::Auth::Admin::Tables::UserSecret.new(self).panel resource

    hr

    columns do
      column do
        Kit::Auth::Admin::Tables::User.new(self).panel resource.user_id
      end

      column do
        Kit::Auth::Admin::Tables::Application.new(self).panel resource.application
      end
    end
  end

end
=end
