module Kit::Auth::Admin::Application

  def self.register_resource(modeL: nil, name: nil, namespace: nil, menu_opts: nil)
    model     ||= Kit::Auth::Models::Read::Application
    name      ||= 'Application'
    namespace ||= :kit_auth
    menu_opts = {
      label:  name,
      parent: 'Auth',
    }.merge(menu_opts || {})

    ActiveAdmin.register model, as: name, namespace: namespace  do
      menu menu_opts

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

    [:ok]
  end

end
