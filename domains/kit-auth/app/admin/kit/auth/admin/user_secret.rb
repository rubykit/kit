module Kit::Auth::Admin::UserSecret
end

ActiveAdmin.register Kit::Auth::Models::Read::UserSecret, as: 'UserSecret', namespace: :kit_auth do
  menu label: 'UserSecrets', parent: 'Users'

  actions :all, except: [:new, :edit, :destroy]

  controller do
    def scoped_collection
      super.preload(:application, :user)
    end
  end

  index do
    Kit::Auth::Admin::Tables::UserSecret.new(self).index
  end

  show do
    Kit::Auth::Admin::Tables::UserSecret.new(self).panel resource

    hr

    columns do
      column do
        Kit::Auth::Admin::Tables::User.new(self).panel resource.user
      end

      column do
        Kit::Auth::Admin::Tables::Application.new(self).panel resource.application
      end
    end
  end

end
