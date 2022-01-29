module Kit::Auth::Admin::UserOauthSecret

  def self.register_resource(modeL: nil, name: nil, namespace: nil, menu_opts: nil)
    model     ||= Kit::Auth::Models::Read::UserOauthSecret
    name      ||= 'UserOauthSecret'
    namespace ||= :kit_auth
    menu_opts = {
      label:  name,
      parent: 'Users',
    }.merge(menu_opts || {})

    ActiveAdmin.register model, as: name, namespace: namespace  do
      menu menu_opts

      actions :all, except: [:new, :edit, :destroy]

      index do
        Kit::Auth::Admin::Tables::UserOauthSecret.new(self).index
      end

      show do

        columns do
          column do
            Kit::Auth::Admin::Tables::UserOauthSecret.new(self).panel(resource,
              attrs_except: [:provider, :provider_uid, :data],
            )
          end

          column do
            Kit::Auth::Admin::Tables::UserOauthSecret.new(self).panel(resource,
              title:      'Provider data',
              attrs_only: [:provider, :provider_uid, :data],
            )
          end
        end

        hr

        Kit::Auth::Admin::Tables::UserOauthSecret.new(self).panel_list(resource.user_oauth_secrets,
          title:        'UserOauthSecrets',
          attrs_list:   :all,
          attrs_except: [:user_oauth_identity],
        )
      end
    end

    [:ok]
  end

end
