module Kit::Auth::Admin::Resources::UserSecret

  def self.register_resource(modeL: nil, name: nil, namespace: nil, menu_opts: nil)
    model     ||= Kit::Auth::Models::Read::UserSecret
    name      ||= 'UserSecret'
    namespace ||= :kit_auth
    menu_opts = {
      label:  name,
      parent: 'Users',
    }.merge(menu_opts || {})

    ActiveAdmin.register model, as: name, namespace: namespace do
      menu menu_opts

      actions :all, except: [:new, :edit, :destroy]

      self.instance_eval(&Kit::Auth::Admin::Resources::UserSecret.setup_index)
      self.instance_eval(&Kit::Auth::Admin::Resources::UserSecret.setup_show)
    end

    [:ok]
  end

  def self.setup_index
    proc do
      controller do
        def scoped_collection # rubocop:disable Lint/NestedMethodDefinition
          super.preload(:application, :user)
        end
      end

      index do
        Kit::Admin::Services::Renderers::Index.render(ctx: self,
          attrs: Kit::Auth::Admin::Attributes::UserSecret.index,
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
              title: 'UserSecret meta',
              attrs: Kit::Auth::Admin::Attributes::UserSecret.show.slice(:id, :created_at, :updated_at, :user, :application),
            )
          end

          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              title: 'UserSecret secret',
              attrs: Kit::Auth::Admin::Attributes::UserSecret.show.slice(:active, :expires_in, :scopes, :secret, :revoked_at),
            )
          end
        end
      end
    end
  end

end
