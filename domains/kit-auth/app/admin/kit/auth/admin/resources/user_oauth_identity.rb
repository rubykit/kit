module Kit::Auth::Admin::Resources::UserOauthIdentity

  def self.register_resource(modeL: nil, name: nil, namespace: nil, menu_opts: nil)
    model     ||= Kit::Auth::Models::Read::UserOauthIdentity
    name      ||= 'UserOauthIdentity'
    namespace ||= :kit_auth
    menu_opts = {
      label:  name,
      parent: 'Users',
    }.merge(menu_opts || {})

    ActiveAdmin.register model, as: name, namespace: namespace  do
      menu menu_opts

      actions :all, except: [:new, :edit, :destroy]

      self.instance_eval(&Kit::Auth::Admin::Resources::UserOauthIdentity.setup_index)
      self.instance_eval(&Kit::Auth::Admin::Resources::UserOauthIdentity.setup_show)
    end

    [:ok]
  end

  def self.setup_index
    proc do
      index do
        Kit::Admin::Services::Renderers::Index.render(ctx: self,
          attrs: Kit::Auth::Admin::Attributes::UserOauthIdentity.index,
        )
      end
    end
  end

  def self.setup_show
    proc do
      show do
        columns do
          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              attrs: Kit::Auth::Admin::Attributes::UserOauthIdentity.show.except(:provider, :provider_uid, :data),
            )
          end

          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              title: 'Provider data',
              attrs: Kit::Auth::Admin::Attributes::UserOauthIdentity.show.slice(:provider, :provider_uid, :data),
            )
          end
        end

        hr

        Kit::Admin::Services::Renderers::PanelList.render(ctx: self,
          title:    'UserOauthSecrets',
          attrs:    Kit::Auth::Admin::Attributes::UserOauthSecret.list.except(:user_oauth_identity),
          relation: resource.user_oauth_secrets,
        )
      end
    end
  end

end
