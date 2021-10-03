module Kit::Auth::Admin::Application
end

ActiveAdmin.register Kit::Auth::Models::Read::Application, as: 'Application', namespace: :kit_auth do
  menu label: 'Application', parent: 'Auth'

  actions :all, except: [:new, :edit, :destroy]

  index do
    Kit::Auth::Admin::Tables::Application.new(self).index
  end

  show do
    Kit::Auth::Admin::Tables::Application.new(self).panel resource

    hr

    columns do
      column do
        Kit::Auth::Admin::Tables::UserSecret.new(self).panel_list resource.user_access_tokens, attrs_except: [:application]
      end
    end
  end

end
