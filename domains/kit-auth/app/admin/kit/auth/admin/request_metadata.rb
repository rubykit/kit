require 'browser'

module Kit::Auth::Admin::RequestMetadata
end

ActiveAdmin.register Kit::Auth::Models::Write::RequestMetadata, as: 'RequestMetadata', namespace: :kit_auth_admin do
  menu parent: 'Users'

  actions :all, except: [:new, :edit, :destroy]

  index do
    Kit::Auth::Admin::Tables::RequestMetadata.new(self).index
  end

  show do
    columns do
      column do
        Kit::Auth::Admin::Tables::RequestMetadata.new(self).panel resource, attrs_list: :limited
      end

      column do
        Kit::Auth::Admin::Tables::User.new(self).panel resource.user
      end
    end

    columns do
      column do
        Kit::Auth::Admin::Tables::RequestMetadata.new(self).panel resource, attrs_list: :ip
      end

      column do
        Kit::Auth::Admin::Tables::RequestMetadata.new(self).panel resource, attrs_list: :user_agent
      end

      column do
        Kit::Auth::Admin::Tables::RequestMetadata.new(self).panel resource, attrs_list: :utm
      end
    end
  end

end
