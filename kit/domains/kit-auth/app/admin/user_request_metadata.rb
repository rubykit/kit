require 'browser'

ActiveAdmin.register Kit::Auth::Models::Write::UserRequestMetadata, as: 'UserRequestMetadata', namespace: :kit_auth_admin do
  menu parent: 'Users'

  actions :all, except: [:new, :edit, :destroy]

  permit_params :email#, :password, :password_confirmation

  index do
    Kit::Auth::Admin::Tables::UserRequestMetadata.new(self).index
  end

  show do
    columns do
      column do
        Kit::Auth::Admin::Tables::UserRequestMetadata.new(self).panel resource, attrs_list: :limited
      end

      column do
        Kit::Auth::Admin::Tables::User.new(self).panel resource.user
      end
    end

    columns do
      column do
        Kit::Auth::Admin::Tables::UserRequestMetadata.new(self).panel resource, attrs_list: :ip
      end

      column do
        Kit::Auth::Admin::Tables::UserRequestMetadata.new(self).panel resource, attrs_list: :user_agent
      end

      column do
        Kit::Auth::Admin::Tables::UserRequestMetadata.new(self).panel resource, attrs_list: :utm
      end
    end
  end

end
