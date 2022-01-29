module Kit::Auth::Admin::UserSecret

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

      controller do
        def scoped_collection
          super.preload(:application, :user)
        end
      end

      index do
        Kit::Auth::Admin::Tables::UserSecret.new(self).index
      end

      show do
        Kit::Auth::Admin::Tables::UserSecret.new(self).panel resource

        hr

        columns do
          column do
            Kit::Auth::Admin::Tables::User.new(self).panel resource.user
          end

          column do
            Kit::Auth::Admin::Tables::Application.new(self).panel resource.application
          end
        end
      end
    end

    [:ok]
  end

end
