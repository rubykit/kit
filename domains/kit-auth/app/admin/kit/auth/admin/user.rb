module Kit::Auth::Admin::User
end

ActiveAdmin.register Kit::Auth::Models::Write::User, as: 'User', namespace: :kit_auth do
  menu label: 'Users'

  actions :all, except: [:new, :edit, :destroy]

  permit_params :email #, :password, :password_confirmation

  index do
    Kit::Auth::Admin::Tables::User.new(self).index
  end

  show do
    Kit::Auth::Admin::Tables::User.new(self).panel resource

    hr

    Kit::Auth::Admin::Tables::UserOauthIdentity.new(self).panel_list(resource.user_oauth_identities,
      title:        'UserOauthIdentities',
      attrs_list:   :all,
      attrs_except: [:user, :data],
    )
  end

  filter :email
=begin
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
=end

end
