module Kit::Auth::Admin::Resources::UserOauthSecret

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

      self.instance_eval(&Kit::Auth::Admin::Resources::UserOauthSecret.setup_index)
      self.instance_eval(&Kit::Auth::Admin::Resources::UserOauthSecret.setup_show)
    end

    [:ok]
  end

  def self.setup_index
    proc do
      controller do
        def scoped_collection # rubocop:disable Lint/NestedMethodDefinition
          super.preload(:user_oauth_identity)
        end
      end

      index do
        Kit::Admin::Services::Renderers::Index.render(ctx: self,
          attrs: Kit::Auth::Admin::Attributes::UserOauthSecret.index,
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
              attrs: Kit::Auth::Admin::Attributes::UserOauthSecret.show.except(:user_oauth_identity),
            )
          end

          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource.user_oauth_identity,
              attrs: Kit::Auth::Admin::Attributes::UserOauthIdentity.show,
            )
          end
        end
      end
    end
  end

end
