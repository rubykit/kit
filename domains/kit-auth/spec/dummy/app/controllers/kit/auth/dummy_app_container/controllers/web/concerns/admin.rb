module Kit::Auth::DummyAppContainer::Controllers::Web::Concerns::Admin

  extend ActiveSupport::Concern

  def current_admin_user
    session_user
  end

  def authenticate_admin_user!
    user = current_admin_user

    if !user
      redirect_to Kit::Router::Adapters::Http::Mountpoints.path(id: 'web|home')
    end
  end

end
