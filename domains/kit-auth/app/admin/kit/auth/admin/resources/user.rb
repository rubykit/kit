module Kit::Auth::Admin::Resources::User

  def self.register_resource(modeL: nil, name: nil, namespace: nil, menu_opts: nil)
    model     ||= Kit::Auth::Models::Write::User
    name      ||= 'AuthUsers'
    namespace ||= :kit_auth
    menu_opts = {
      label:  name,
      parent: 'Users',
    }.merge(menu_opts || {})

    ActiveAdmin.register model, as: name, namespace: namespace  do
      menu menu_opts

      actions :all, except: [:new, :edit, :destroy]

      self.instance_eval(&Kit::Auth::Admin::Resources::User.setup_index)
      self.instance_eval(&Kit::Auth::Admin::Resources::User.setup_show)
    end

    [:ok]
  end

  def self.setup_index
    proc do
      filter :id
      filter :created_at
      filter :email

      index do
        Kit::Admin::Services::Renderers::Index.render(ctx: self,
          attrs: Kit::Auth::Admin::Attributes::User.index,
        )
      end
    end
  end

  def self.setup_show
    proc do
      show do
        Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
          attrs: Kit::Auth::Admin::Attributes::User.show,
        )

        hr

        Kit::Admin::Services::Renderers::PanelList.render(ctx: self,
          attrs:    Kit::Auth::Admin::Attributes::UserOauthIdentity.list.except(:user, :data),
          relation: resource.user_oauth_identities,
          title:    'UserOauthIdentities',
        )
      end
    end
  end

end
