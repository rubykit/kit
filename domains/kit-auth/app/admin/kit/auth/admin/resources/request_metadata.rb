require 'browser'

module Kit::Auth::Admin::Resources::RequestMetadata

  # We override the Default Kit::Domain::Admin one to add user support.
  def self.register_resource(modeL: nil, name: nil, namespace: nil, menu_opts: nil)
    model     ||=  Kit::Auth::Models::Write::RequestMetadata
    name      ||= 'RequestMetadata'
    namespace ||= :kit_auth
    menu_opts = {
      label:  name,
      parent: 'Developer',
    }.merge(menu_opts || {})

    ActiveAdmin.register model, as: name, namespace: namespace  do
      menu menu_opts

      actions :all, except: [:new, :edit, :destroy]

      self.instance_eval(&Kit::Auth::Admin::Resources::RequestMetadata.setup_index)
      self.instance_eval(&Kit::Auth::Admin::Resources::RequestMetadata.setup_show)
    end

    [:ok]
  end

  def self.setup_index
    proc do
      controller do
        def scoped_collection # rubocop:disable Lint/NestedMethodDefinition
          super.preload(:user)
        end
      end

      index do
        Kit::Admin::Services::Renderers::Index.render(ctx: self,
          attrs: Kit::Auth::Admin::Attributes::RequestMetadata.index,
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
              attrs: Kit::Auth::Admin::Attributes::RequestMetadata.limited,
            )
          end

          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource.user,
              attrs: Kit::Auth::Admin::Attributes::User.show,
            )
          end
        end

        hr

        columns do
          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              attrs: Kit::Auth::Admin::Attributes::RequestMetadata.ip,
            )
          end

          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              attrs: Kit::Auth::Admin::Attributes::RequestMetadata.user_agent,
            )
          end

          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              attrs: Kit::Auth::Admin::Attributes::RequestMetadata.utm,
            )
          end
        end
      end
    end
  end

end
